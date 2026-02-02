//
//  GithubUser.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

struct GithubUser: Codable, Equatable, Identifiable, Sendable {
    let id: Int
    let login: String
    let name: String?
    let bio: String?
    let location: String?
    let followers: Int
    let following: Int
    let publicRepos: Int
    let avatarURL: URL?
    let htmlURL: URL?

    enum CodingKeys: String, CodingKey {
        case id, login, name, bio, location, followers, following
        case publicRepos = "public_repos"
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}
