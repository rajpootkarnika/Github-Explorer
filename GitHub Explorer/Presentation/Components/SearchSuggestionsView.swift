//
//  SearchSuggestionsView.swift
//  GitHub Explorer
//
//  Created by Karnika on 31/01/26.
//

import SwiftUI

struct SearchSuggestionsView: View {
    let suggestions: [String]
    let onTap: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Try searching")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 18)

            FlowLayout(items: suggestions) { item in
                Button {
                    onTap(item)
                } label: {
                    Text(item)
                        .font(.footnote.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(.thinMaterial)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
        }
        .padding(.top, 10)
    }
}
