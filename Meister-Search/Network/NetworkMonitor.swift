//
//  NetworkMonitor.swift
//  Meister-Search
//
//  Created by Artsem Lemiasheuski on 18.02.22.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue.global(qos: .background)
    private let monitor = NWPathMonitor()

    public private(set) var isConnected = false

    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            self.isConnected = path.status == .satisfied
        }
    }

    public func stopMonitoring() {
        monitor.cancel()
    }
}
