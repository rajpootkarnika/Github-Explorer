//
//  SavedReposViewModel.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation
import Combine

@MainActor
final class SavedReposViewModel: ObservableObject {
    @Published private(set) var saved: [SavedRepoEntity] = []
    @Published private(set) var errorMessage: String?

    private let store: SavedRepoStoring

    init(store: SavedRepoStoring) {
        self.store = store
    }

    func load() {
        do {
            errorMessage = nil
            saved = try store.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            saved = []
        }
    }

    func delete(at offsets: IndexSet) {
        do {
            for index in offsets {
                let entity = saved[index]
                try store.remove(repoId: entity.id)
            }
            load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
