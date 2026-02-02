//
//  RepoSearchResponse.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

struct RepoSearchResponse: Codable, Sendable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repo]
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
