//
//  GithubEndpoints.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

enum GithubAPI {
    struct SearchRepos: APIEndpoint {
        let query: String
        let sort: RepoSort
        let page: Int
        let perPage: Int

        var path: String { "/search/repositories" }
        var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "sort", value: sort.rawValue),
                URLQueryItem(name: "order", value: "desc"),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
        }
    }

    struct RepoDetail: APIEndpoint {
        let owner: String
        let repo: String

        var path: String { "/repos/\(owner)/\(repo)" }
        var queryItems: [URLQueryItem] { [] }
    }

    struct UserProfile: APIEndpoint {
        let username: String

        var path: String { "/users/\(username)" }
        var queryItems: [URLQueryItem] { [] }
    }
}

