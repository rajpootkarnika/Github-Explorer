//
//  NetworkMonitor.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import Foundation
import Network
import Combine

@MainActor
final class NetworkMonitor: ObservableObject {
    @Published private(set) var isOnline: Bool = true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    init() {
        monitor.pathUpdateHandler = { path in
            let online = (path.status == .satisfied)

            Task { @MainActor in
                self.isOnline = online
            }
        }
        monitor.start(queue: queue)
    }
}
