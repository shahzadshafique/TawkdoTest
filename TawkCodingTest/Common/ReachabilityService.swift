//
//  Reachability.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 30/10/2022.
//

import Combine
import Network

final class ReachabilityService: ObservableObject {

    @Published var isNetworkAvailable: Bool = true
    private let monitor = NWPathMonitor()
    
    static let shared = ReachabilityService()

    private init() {
        setUpMonitoring()
    }

    deinit {
        monitor.cancel()
    }
}

extension ReachabilityService {
    private func setUpMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkAvailable = path.status != .unsatisfied
            }
        }

        monitor.start(queue: .global())
    }
}
