//
//  SearchView.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()

    private let chipColors: [Color] = [.blue, .purple, .pink, .orange, .green, .teal]

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background()
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    header
                    searchField
                    sortPicker
                    content
                }
                .padding(.horizontal)
                .padding(.top, 6)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Header
    private var header: some View {
        Text("GitHub Explorer")
            .font(.largeTitle.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Search Bar
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search repositories", text: $vm.query)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
                .onChange(of: vm.query) { _, newValue in
                    vm.onQueryChanged(newValue)
                }

            if !vm.query.isEmpty {
                Button {
                    vm.clearSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.accent.opacity(0.25), lineWidth: 1)
                )
        )
    }

    // MARK: - Sort Picker
    private var sortPicker: some View {
        Picker("", selection: $vm.sort) {
            Text("Stars").tag(RepoSort.stars)
            Text("Updated").tag(RepoSort.updated)
        }
        .pickerStyle(.segmented)
        .onChange(of: vm.sort) { _, _ in
            vm.onSortChanged()
        }
        .tint(AppTheme.accent)
    }

    // MARK: - Content Switch
    @ViewBuilder
    private var content: some View {
        if vm.isLoading && vm.repos.isEmpty {
            ProgressView("Searching...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 24)

        } else if let msg = vm.errorMessage, vm.repos.isEmpty {
            ErrorStateView(message: msg, retry: vm.retry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        } else if vm.repos.isEmpty {
            emptyState
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        } else {
            resultsList
        }
    }

    // MARK: - Empty State (Colorful)
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 12)

            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.thinMaterial)
                        .frame(width: 72, height: 72)
                        .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))

                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 28, weight: .semibold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(AppTheme.accent)
                }

                Text("No Results")
                    .font(.title3.weight(.semibold))

                Text(vm.emptyMessage ?? "Start typing to search repos")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            }
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppTheme.accent.opacity(0.18),
                                Color(.systemBackground).opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(AppTheme.accent.opacity(0.2), lineWidth: 1)
                    )
            )

            VStack(alignment: .leading, spacing: 10) {
                Text("Try searching")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 95), spacing: 10)], spacing: 10) {
                    ForEach(Array(vm.suggestions.enumerated()), id: \.offset) { index, text in
                        let c = chipColors[index % chipColors.count]

                        Button {
                            vm.selectSuggestion(text)
                        } label: {
                            Text(text)
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(c)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(c.opacity(0.14))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .stroke(c.opacity(0.22), lineWidth: 1)
                                        )
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 24)
        }
        .padding(.horizontal)
    }

    // MARK: - Results List
    private var resultsList: some View {
        List {
            ForEach(vm.repos) { repo in
                NavigationLink {
                    RepoDetailView(owner: repo.owner.login, repo: repo.name)
                } label: {
                    RepoRowView(repo: repo)
                }
                .onAppear {
                    // ✅ Trigger next page when last item appears
                    if repo.id == vm.repos.last?.id {
                        vm.loadNextPage()
                    }
                }
            }

            if vm.isLoadingNextPage {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden) // keeps gradient visible behind List
        .refreshable {
            vm.startFreshSearch()
        }
    }
}
