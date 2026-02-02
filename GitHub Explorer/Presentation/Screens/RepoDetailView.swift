//
//  RepoDetailView.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import SwiftUI
import SwiftData

struct RepoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedEntities: [SavedRepoEntity]

    @StateObject private var vm: RepoDetailViewModel

    @State private var bannerMessage: String?
    @State private var bannerColor: Color = .green

    init(owner: String, repo: String) {
        _vm = StateObject(wrappedValue: RepoDetailViewModel(owner: owner, name: repo))
    }

    var body: some View {
        Group {
            if vm.isLoading && vm.repo == nil {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let msg = vm.errorMessage, vm.repo == nil {
                ErrorStateView(message: msg, retry: vm.load)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let repo = vm.repo {
                repoContent(repo)
            } else {
                // ✅ fallback so you never see blank screen
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading details…")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            vm.load()
        }
        .overlay(alignment: .top) {
            if let msg = bannerMessage {
                bannerView(msg)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: bannerMessage)
    }

    // MARK: - Main Content
    @ViewBuilder
    private func repoContent(_ repo: Repo) -> some View {
        List {
            Section("Repository") {
                Text(repo.fullName)
                    .font(.headline)

                if let desc = repo.description, !desc.isEmpty {
                    Text(desc)
                        .foregroundStyle(.secondary)
                }

                Link("Open on GitHub", destination: repo.htmlURL)
            }

            Section("Stats") {
                Label("Stars: \(repo.stargazersCount)", systemImage: "star.fill")
                Label("Forks: \(repo.forksCount)", systemImage: "tuningfork")
                Label("Open issues: \(repo.openIssuesCount)", systemImage: "exclamationmark.circle")

                if let lang = repo.language {
                    Label("Language: \(lang)", systemImage: "chevron.left.forwardslash.chevron.right")
                }

                Label("Updated: \(repo.updatedAt.formatted(date: .abbreviated, time: .omitted))",
                      systemImage: "clock")
            }

            Section("Owner") {
                NavigationLink {
                    UserProfileView(username: repo.owner.login)
                } label: {
                    Text(repo.owner.login)
                }
            }
        }
        .toolbar {
            Button {
                toggleSave(repo)
            } label: {
                Image(systemName: isSaved(repo) ? "bookmark.fill" : "bookmark")
            }
            .accessibilityLabel(isSaved(repo) ? "Remove bookmark" : "Bookmark repo")
        }
    }

    // MARK: - SwiftData Bookmarking
    private func isSaved(_ repo: Repo) -> Bool {
        savedEntities.contains(where: { $0.id == repo.id })
    }

    private func toggleSave(_ repo: Repo) {
        if let existing = savedEntities.first(where: { $0.id == repo.id }) {
            modelContext.delete(existing)
            try? modelContext.save()
            showBanner(message: "Removed from Saved", color: .red)
        } else {
            modelContext.insert(SavedRepoEntity(repo: repo))
            try? modelContext.save()
            showBanner(message: "Saved successfully", color: .green)
        }
    }

    // MARK: - Banner
    private func showBanner(message: String, color: Color) {
        bannerMessage = message
        bannerColor = color

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            bannerMessage = nil
        }
    }

    private func bannerView(_ message: String) -> some View {
        Text(message)
            .font(.subheadline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(bannerColor.opacity(0.9))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
    }
}
