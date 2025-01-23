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
    case decodingError
    case unknownError
}

public func networkRequest<T: Decodable>(
    urlStr: String,
    method: HTTPMethod,
    data: Data?,
    model: T.Type,
    query: [String: Any]? = nil,
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
    
    var request = URLRequest(url: url)

    request.allHTTPHeaderFields = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(Key.JWT_Token)"
    ]
    request.httpBody = data
    request.method = method
    
    AF.request(request)
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
