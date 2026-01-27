//
//  NetworkError.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/27/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidParameters
    case invalidURL
    case invalidResponse
    case invalidToken
    case decodingError
    case serverError(code: String, message: String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidParameters:
            return "잘못된 파라미터입니다."
        case .invalidURL:
            return "잘못된 URL입니다."
        case .invalidResponse:
            return "잘못된 응답입니다."
        case .invalidToken:
            return "토큰이 유효하지 않습니다."
        case .decodingError:
            return "데이터 디코딩에 실패했습니다."
        case .serverError(_, let message):
            return message
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}

struct ErrorResponse: Decodable {
    let code: String
    let msg: [String]
}
