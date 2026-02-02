//
//  UserProfileViewModel.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import SwiftUI
import Combine

@MainActor
final class UserProfileViewModel: ObservableObject {
    @Published private(set) var user: GithubUser?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let api: GithubRepositoryProtocol
    private let username: String

    init(username: String, api: GithubRepositoryProtocol? = nil) {
        self.username = username
        self.api = api ?? GithubRepository()
    }

    func load() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        Task {
            do {
                self.user = try await api.userProfile(username: username)
            } catch {
                self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
