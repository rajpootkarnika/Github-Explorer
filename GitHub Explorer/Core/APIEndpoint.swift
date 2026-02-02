//
//  APIEndpoint.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
}

extension APIEndpoint {
    var baseURL: URL { URL(string: "https://api.github.com")! }
    var method: HTTPMethod { .get }
    var headers: [String: String] {
        [
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28"
        ]
    }

    func makeURLRequest() throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.timeoutInterval = 20
        return request
    }
}
