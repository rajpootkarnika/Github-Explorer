//
//  SearchViewModel.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {

    // MARK: - Inputs
    @Published var query: String = ""
    @Published var sort: RepoSort = .stars

    // MARK: - Outputs
    @Published private(set) var repos: [Repo] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isLoadingNextPage: Bool = false
    @Published private(set) var errorMessage: String? = nil
    @Published private(set) var emptyMessage: String? = "Start typing to search repos"
    @Published private(set) var canLoadMore: Bool = false

    // MARK: - Suggestions
    let suggestions: [String] = ["swiftui", "ios", "combine", "async-await", "mvvm"]

    // MARK: - Dependencies
    private let repoService: GithubRepositoryProtocol
    private let cache = CacheStore()

    // MARK: - Paging / Tasks
    private var page: Int = 1
    private let perPage: Int = 20

    private var debounceTask: Task<Void, Never>?
    private var currentTask: Task<Void, Never>?

    private var searchId = UUID()

    init(repo: GithubRepositoryProtocol? = nil) {
        self.repoService = repo ?? GithubRepository()
    }

    // MARK: - Public Actions
    func onQueryChanged(_ newValue: String) {
        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            clearSearch()
            return
        }

        errorMessage = nil
        emptyMessage = nil

        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 700_000_000)
            await self.startFreshSearchIfNeeded()
        }
    }

    func onSortChanged() {
        startFreshSearch()
    }

    func selectSuggestion(_ text: String) {
        query = text
        onQueryChanged(text)
    }

    func clearSearch() {
        debounceTask?.cancel()
        currentTask?.cancel()

        searchId = UUID()

        query = ""
        page = 1
        repos = []
        canLoadMore = false
        isLoading = false
        isLoadingNextPage = false
        errorMessage = nil
        emptyMessage = "Start typing to search repos"
    }

    func retry() {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            clearSearch()
        } else {
            startFreshSearch()
        }
    }

    func loadNextPage() {
        guard canLoadMore, !isLoadingNextPage, !isLoading else { return }
        page += 1
        startSearch(page: page, isNextPage: true)
    }

    // MARK: - Private
    private func startFreshSearchIfNeeded() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            clearSearch()
            return
        }

        if trimmed.count < 2 {
            repos = []
            canLoadMore = false
            isLoading = false
            isLoadingNextPage = false
            errorMessage = nil
            emptyMessage = "Type at least 2 characters"
            return
        }

        startFreshSearch()
    }

    func startFreshSearch() {
        currentTask?.cancel()
        debounceTask?.cancel()

        searchId = UUID()

        page = 1
        repos = []
        canLoadMore = false
        isLoading = false
        isLoadingNextPage = false
        errorMessage = nil
        emptyMessage = nil

        startSearch(page: page, isNextPage: false)
    }

    private func startSearch(page: Int, isNextPage: Bool) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // Cancel previous request
        currentTask?.cancel()

        if isNextPage {
            isLoadingNextPage = true
        } else {
            isLoading = true
        }

        errorMessage = nil
        emptyMessage = nil

        let currentId = searchId
        let currentQuery = trimmed
        let currentSort = sort
        let currentPage = page

        let cacheKey = "search_\(currentQuery)_\(currentSort.rawValue)_page_\(currentPage)_per_\(perPage)"

        currentTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await repoService.searchRepos(
                    query: currentQuery,
                    sort: currentSort,
                    page: currentPage,
                    perPage: perPage
                )

                guard self.searchId == currentId else { return }
                guard !Task.isCancelled else { return }

                cache.save(response, key: cacheKey)

                if isNextPage {
                    let existing = Set(self.repos.map(\.id))
                    let newItems = response.items.filter { !existing.contains($0.id) }
                    self.repos.append(contentsOf: newItems)
                } else {
                    self.repos = response.items
                }

                self.canLoadMore = response.items.count == self.perPage
                self.emptyMessage = self.repos.isEmpty ? "No results found for “\(currentQuery)”" : nil
                self.errorMessage = nil

            } catch {
                guard self.searchId == currentId else { return }
                guard !Task.isCancelled else { return }

                if let cached: RepoSearchResponse = cache.load(RepoSearchResponse.self, key: cacheKey) {
                    if isNextPage {
                        let existing = Set(self.repos.map(\.id))
                        let newItems = cached.items.filter { !existing.contains($0.id) }
                        self.repos.append(contentsOf: newItems)
                    } else {
                        self.repos = cached.items
                    }

                    self.canLoadMore = cached.items.count == self.perPage
                    self.emptyMessage = self.repos.isEmpty ? "No cached results available." : nil
                    self.errorMessage = nil
                } else {
                    self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                    self.canLoadMore = false
                }
            }

            guard self.searchId == currentId else { return }
            self.isLoading = false
            self.isLoadingNextPage = false
        }
    }
}
