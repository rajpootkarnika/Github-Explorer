//
//  CacheStore.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation

final class CacheStore {
    private let folderName = "cache_v1"

    private var baseURL: URL {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let dir = caches.appendingPathComponent(folderName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    func save<T: Encodable>(_ value: T, key: String) {
        let url = baseURL.appendingPathComponent(safeFileName(key) + ".json")
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url, options: [.atomic])
        } catch {}
    }

    func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        let url = baseURL.appendingPathComponent(safeFileName(key) + ".json")
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    private func safeFileName(_ key: String) -> String {
        key.replacingOccurrences(of: "[^a-zA-Z0-9_-]", with: "_", options: .regularExpression)
    }
}
