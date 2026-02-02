//
//  Theme.swift
//  GitHub Explorer
//
//  Created by Karnika on 31/01/26.
//

import SwiftUI

enum AppTheme {

    static let accent = Color.blue   // change to purple / teal if you want

    static func background() -> LinearGradient {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color(.secondarySystemBackground)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static let tabGradient = LinearGradient(
        colors: [
            Color.blue.opacity(0.15),
            Color.purple.opacity(0.15)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}

