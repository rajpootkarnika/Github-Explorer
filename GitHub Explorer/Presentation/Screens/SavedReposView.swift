//
//  SavedReposView.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import SwiftUI

struct SavedReposView: View {
    @StateObject var vm: SavedReposViewModel
    @State private var selectedRepo: Repo?

    var body: some View {
            ZStack {
                AppTheme.background().ignoresSafeArea()

                List {
                    ForEach(vm.saved) { entity in
                        let repo = entity.toRepo()

                        SavedRepoCardRow(repo: repo)
                            .contentShape(Rectangle())   
                            .onTapGesture {
                                selectedRepo = repo
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: vm.delete)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Saved")
            .onAppear { vm.load() }
            .navigationDestination(item: $selectedRepo) { repo in
                RepoDetailView(owner: repo.owner.login, repo: repo.name)
            }
        }

    private var savedEmptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "bookmark.circle.fill")
                .font(.system(size: 44))
                .foregroundStyle(AppTheme.accent)

            Text("No Saved Repos")
                .font(.title3.weight(.semibold))

            Text("Bookmark repositories from the details screen to see them here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppTheme.accent.opacity(0.18), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
    }
}
