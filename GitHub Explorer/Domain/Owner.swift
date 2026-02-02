//
//  Owner.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

struct Owner: Codable, Equatable, Hashable, Sendable {
    let login: String
    let avatarURL: URL?
    let htmlURL: URL?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}
