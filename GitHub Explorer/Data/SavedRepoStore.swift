//
//  SavedRepoStore.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation
import SwiftData

protocol SavedRepoStoring {
    func fetchAll() throws -> [SavedRepoEntity]
    func isSaved(repoId: Int) throws -> Bool
    func save(repo: Repo) throws
    func remove(repoId: Int) throws
}

final class SwiftDataSavedRepoStore: SavedRepoStoring {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() throws -> [SavedRepoEntity] {
        var descriptor = FetchDescriptor<SavedRepoEntity>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        descriptor.fetchLimit = 500
        return try context.fetch(descriptor)
    }

    func isSaved(repoId: Int) throws -> Bool {
        let predicate = #Predicate<SavedRepoEntity> { $0.id == repoId }
        var descriptor = FetchDescriptor<SavedRepoEntity>(predicate: predicate)
        descriptor.fetchLimit = 1
        return try !context.fetch(descriptor).isEmpty
    }

    func save(repo: Repo) throws {
        if try isSaved(repoId: repo.id) { return }
        context.insert(SavedRepoEntity(repo: repo))
        try context.save()
    }

    func remove(repoId: Int) throws {
        let predicate = #Predicate<SavedRepoEntity> { $0.id == repoId }
        let descriptor = FetchDescriptor<SavedRepoEntity>(predicate: predicate)
        let matches = try context.fetch(descriptor)
        matches.forEach { context.delete($0) }
        try context.save()
    }
}
