//
//  ServiceAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 12/26/24.
//

import Alamofire

enum NetworkError: Error {
    case invalidParameters
    case invalidURL
    case invalidResponse
    case invalidToken
    case decodingError
    case unknownError
}

public func networkRequest<T: Decodable>(
    urlStr: String,
    method: HTTPMethod,
    data: Data?,
    model: T.Type,
    query: [String: Any]? = nil,
    cancelToken: APICancelToken? = nil,
    completion: @escaping (Result<T, Error>) -> Void
) {
    guard var urlComponents = URLComponents(string: baseURL.URL + urlStr) else {
        completion(.failure(NetworkError.invalidURL))
        return
    }
    
    if let parameters = query {
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
    }
    
    guard let url = urlComponents.url else {
        completion(.failure(NetworkError.invalidURL))
        return
    }
    
    guard let token = KeychainManager.read() else {
        completion(.failure(NetworkError.invalidToken))
        return
    }
    
    var request = URLRequest(url: url)

    request.allHTTPHeaderFields = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(token)"
    ]
    request.httpBody = data
    request.method = method
    
    let apiRequest = AF.request(request)
    
    cancelToken?.onRegister {
        apiRequest.cancel()
    }
    
    apiRequest
        .validate(statusCode: 200..<300)
        .responseDecodable(of: model.self) { response in
            if let error = response.error, error.isExplicitlyCancelledError {
                print("[ServiceAPI] ErrorMsg: Request was explicitly cancelled, completion will not be called.")
                return
            }
            
            switch response.result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                if let data = response.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("\n<< [ServiceAPI] ErrorMsg: \(errorMessage)\n")
                } else {
                    print("\n<< [ServiceAPI] Error.localizedDescription: \(error.localizedDescription)\n")
                }
                
                completion(.failure(error))
            }
        }
}

// TODO: APICancelToken 넣기
public func uploadNetworkRequest<T: Decodable>(
    urlStr: String,
    method: HTTPMethod,
    imageData: [Data]?,
    parameter: [String: Any]?,
    model: T.Type,
    completion: @escaping (Result<T, Error>) -> Void
) {
    guard let url = URL(string: baseURL.URL + urlStr) else {
        completion(.failure(NetworkError.invalidURL))
        return
    }
    
    guard let token = KeychainManager.read() else {
        completion(.failure(NetworkError.invalidToken))
        return
    }

    let headers: HTTPHeaders = [
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer \(token)"
    ]
    
    AF.upload(multipartFormData: { multipartFormData in
        if let parameter = parameter, let jsonData = try? JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted) {
            multipartFormData.append(jsonData, withName: "reviewPost", mimeType: "application/json")
        }
        
        if let imageData = imageData {
            imageData.forEach { image in
                let imageFileName = "\(UUID().uuidString).jpeg"
                multipartFormData.append(image, withName: "files", fileName: imageFileName, mimeType: "image/jpeg")
            }
        }
    }, to: url, headers: headers)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: model.self) { response in
        switch response.result {
        case .success(let decodedData):
            completion(.success(decodedData))
        case .failure(let error):
            if let data = response.data,
               let errorMessage = String(data: data, encoding: .utf8) {
                print("\n<< [ServiceAPI] ErrorMsg: \(errorMessage)\n")
            } else {
                print("\n<< [ServiceAPI] Error.localizedDescription: \(error.localizedDescription)\n")
            }
            
            completion(.failure(error))
        }
    }
}
