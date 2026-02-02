//
//  SavedRepoEntity.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation
import SwiftData

@Model
final class SavedRepoEntity {
    @Attribute(.unique) var id: Int

    var fullName: String
    var name: String
    var ownerLogin: String
    var repoURLString: String
    var desc: String?
    var language: String?
    var stars: Int
    var forks: Int
    var openIssues: Int
    var updatedAt: Date
    var savedAt: Date

    init(repo: Repo) {
        self.id = repo.id
        self.fullName = repo.fullName
        self.name = repo.name
        self.ownerLogin = repo.owner.login
        self.repoURLString = repo.htmlURL.absoluteString
        self.desc = repo.description
        self.language = repo.language
        self.stars = repo.stargazersCount
        self.forks = repo.forksCount
        self.openIssues = repo.openIssuesCount
        self.updatedAt = repo.updatedAt
        self.savedAt = Date()
    }
}
