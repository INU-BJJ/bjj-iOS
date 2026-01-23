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

public enum ResponseType {
    case json
    case html
}

// TODO: Swift Concurrency(async/await)로 리팩토링
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

    // accessToken이 없으면 tempToken 사용 (회원가입 플로우용)
    let token: String
    if let accessToken = KeychainManager.read(key: .accessToken) {
        token = accessToken
    } else if let tempToken = KeychainManager.read(key: .tempToken) {
        token = tempToken
    } else {
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
            
            // 200번대 성공 응답이지만 빈 응답인 경우 먼저 처리
            if let statusCode = response.response?.statusCode,
               (200..<300).contains(statusCode) {
                
                let isEmpty = response.data?.isEmpty ?? true
                
                if isEmpty, let emptyResponse = EmptyResponse() as? T {
                    print("[ServiceAPI] Success with empty response (status: \(statusCode))")
                    completion(.success(emptyResponse))
                    return
                }
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

// HTML/String 응답을 받는 API 요청
public func networkRequest(
    urlStr: String,
    method: HTTPMethod,
    query: [String: Any]? = nil,
    cancelToken: APICancelToken? = nil,
    responseType: ResponseType,
    completion: @escaping (Result<String, Error>) -> Void
) {
    let base = responseType == .html ? baseURL.homepageURL : baseURL.URL
    guard var urlComponents = URLComponents(string: base + urlStr) else {
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

    var request = URLRequest(url: url)

    // HTML 응답을 받기 위해 Accept 헤더 설정
    request.allHTTPHeaderFields = [
        "Accept": "text/html"
    ]
    request.method = method

    let apiRequest = AF.request(request)

    cancelToken?.onRegister {
        apiRequest.cancel()
    }

    apiRequest
        .validate(statusCode: 200..<300)
        .responseString { response in
            if let error = response.error, error.isExplicitlyCancelledError {
                print("[ServiceAPI] ErrorMsg: Request was explicitly cancelled, completion will not be called.")
                return
            }

            switch response.result {
            case .success(let htmlString):
                completion(.success(htmlString))
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
    
    guard let token = KeychainManager.read(key: .accessToken) else {
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
