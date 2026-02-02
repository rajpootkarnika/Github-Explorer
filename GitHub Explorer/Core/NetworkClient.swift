//
//  NetworkClient.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case httpStatus(Int)
    case decodingFailed
    case rateLimited(resetAt: Date?)
    case underlying(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .httpStatus(let code):
            return "Server error. Status code: \(code)"
        case .decodingFailed:
            return "Could not decode server response."
        case .rateLimited(let resetAt):
            if let resetAt {
                return "GitHub rate limit reached. Try again at \(resetAt.formatted(date: .omitted, time: .shortened))."
            } else {
                return "GitHub rate limit reached. Try again later."
            }
        case .underlying(let msg):
            return msg
        }
    }
}

protocol NetworkServicing {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

final class NetworkClient: NetworkServicing {

    private let session: URLSession
    private let decoder: JSONDecoder
    private let token: String?

    init(session: URLSession = .shared, token: String? = nil) {
        self.session = session
        self.token = token

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        var request = try endpoint.makeURLRequest()

        let token = KeychainStore.load()
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.underlying("Invalid response.")
        }

        if http.statusCode == 403, isRateLimited(http) {
            throw NetworkError.rateLimited(resetAt: parseRateLimitReset(from: http))
        }

        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.httpStatus(http.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    private func isRateLimited(_ http: HTTPURLResponse) -> Bool {
        http.value(forHTTPHeaderField: "X-RateLimit-Remaining") == "0"
    }

    private func parseRateLimitReset(from http: HTTPURLResponse) -> Date? {
        guard let reset = http.value(forHTTPHeaderField: "X-RateLimit-Reset"),
              let seconds = TimeInterval(reset) else { return nil }
        return Date(timeIntervalSince1970: seconds)
    }
}

