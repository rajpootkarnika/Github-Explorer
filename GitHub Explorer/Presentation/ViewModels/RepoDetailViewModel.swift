//
//  RepoDetailViewModel.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation
import Combine

@MainActor
final class RepoDetailViewModel: ObservableObject {
    @Published private(set) var repo: Repo?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let api: GithubRepositoryProtocol
    private let owner: String
    private let name: String

    init(owner: String, name: String, api: GithubRepositoryProtocol? = nil) {
        self.owner = owner
        self.name = name
        self.api = api ?? GithubRepository()
    }

    func load() {
        guard repo == nil else { return }      
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let result = try await api.repoDetail(owner: owner, repo: name)
                self.repo = result
            } catch {
                self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
