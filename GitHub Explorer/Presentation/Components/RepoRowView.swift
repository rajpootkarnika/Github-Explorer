//
//  RepoRowView.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import SwiftUI

struct RepoRowView: View {
    let repo: Repo

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(repo.fullName)
                .font(.headline)

            if let desc = repo.description, !desc.isEmpty {
                Text(desc)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack(spacing: 12) {
                Label("\(repo.stargazersCount)", systemImage: "star.fill")
                Label("\(repo.forksCount)", systemImage: "tuningfork")
                if let lang = repo.language {
                    Text(lang).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Text(repo.updatedAt, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .font(.caption)
        }
        .padding(.vertical, 6)
    }
}
