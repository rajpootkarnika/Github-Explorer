//
//  HTTPError.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

enum HTTPError: LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingFailed
    case noInternet
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .statusCode(let code):
            return "Server error (\(code))"
        case .decodingFailed:
            return "Failed to decode data"
        case .noInternet:
            return "No internet connection"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
