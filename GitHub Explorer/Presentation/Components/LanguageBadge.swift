//
//  LanguageBadge.swift
//  GitHub Explorer
//
//  Created by Karnika on 31/01/26.
//

import SwiftUI

struct LanguageBadge: View {
    let language: String

    var body: some View {
        Text(language)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(languageColor.opacity(0.18))
            .foregroundStyle(languageColor)
            .clipShape(Capsule())
    }

    private var languageColor: Color {
        switch language.lowercased() {
        case "swift": return .orange
        case "java": return .red
        case "python": return .green
        case "ruby": return .pink
        case "c++": return .blue
        default: return .gray
        }
    }
}
