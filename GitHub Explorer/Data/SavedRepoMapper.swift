//
//  SavedRepoMapper.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

extension SavedRepoEntity {
    func toRepo() -> Repo {
        Repo(
            id: id,
            name: name,
            fullName: fullName,
            description: desc,
            language: language,
            stargazersCount: stars,
            forksCount: forks,
            openIssuesCount: openIssues,
            htmlURL: URL(string: repoURLString)!,
            owner: Owner(login: ownerLogin, avatarURL: nil, htmlURL: nil),
            updatedAt: updatedAt
        )
    }
}
