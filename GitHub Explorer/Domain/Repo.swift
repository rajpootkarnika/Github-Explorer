//
//  Repo.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

struct Repo: Codable, Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let htmlURL: URL
    let owner: Owner
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, name, description, language, owner
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case htmlURL = "html_url"
        case updatedAt = "updated_at"
    }
}
