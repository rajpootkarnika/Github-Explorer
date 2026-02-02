//
//  SavedRepoCardRow.swift
//  GitHub Explorer
//
//  Created by Karnika on 31/01/26.
//

import SwiftUI

struct SavedRepoCardRow: View {
    let repo: Repo

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {

                Text(repo.fullName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                if let desc = repo.description {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 10) {
                    StatBadge(
                        icon: "star.fill",
                        value: repo.stargazersCount,
                        color: .yellow
                    )

                    StatBadge(
                        icon: "tuningfork",
                        value: repo.forksCount,
                        color: .blue
                    )

                    if let lang = repo.language {
                        LanguageBadge(language: lang)
                    }

                    Spacer()

                    Text(repo.updatedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.12),
                            Color.blue.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(alignment: .trailing) {
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.trailing, 16)
        }
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
