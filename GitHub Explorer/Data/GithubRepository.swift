//
//  GithubRepository.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

protocol GithubRepositoryProtocol {
    func searchRepos(query: String, sort: RepoSort, page: Int, perPage: Int) async throws -> RepoSearchResponse
    func repoDetail(owner: String, repo: String) async throws -> Repo
    func userProfile(username: String) async throws -> GithubUser
}

final class GithubRepository: GithubRepositoryProtocol {
    private let client: NetworkServicing

    init(client: NetworkServicing = NetworkClient()) {
        self.client = client
    }

    func searchRepos(query: String, sort: RepoSort, page: Int, perPage: Int) async throws -> RepoSearchResponse {
        try await client.request(GithubAPI.SearchRepos(query: query, sort: sort, page: page, perPage: perPage))
    }

    func repoDetail(owner: String, repo: String) async throws -> Repo {
        try await client.request(GithubAPI.RepoDetail(owner: owner, repo: repo))
    }

    func userProfile(username: String) async throws -> GithubUser {
        try await client.request(GithubAPI.UserProfile(username: username))
    }
}
