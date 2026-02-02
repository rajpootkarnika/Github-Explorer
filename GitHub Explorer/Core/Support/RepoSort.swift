//
//  RepoSort.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

enum RepoSort: String, CaseIterable, Identifiable {
    case stars
    case updated

    var id: String { rawValue }

    var title: String {
        switch self {
        case .stars: return "Stars"
        case .updated: return "Updated"
        }
    }
}
