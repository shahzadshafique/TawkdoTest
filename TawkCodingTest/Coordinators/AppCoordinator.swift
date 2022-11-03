//
//  AppCoordinator.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 30/10/2022.
//

import UIKit

protocol Coordinator {
    var children: [Coordinator] { get }
    func start()
}

final class AppCoordinator: Coordinator {
    private(set) var children: [Coordinator] = []
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        let userlistCoordinator = UserListCoordinator(navigationController: navigationController)
        userlistCoordinator.start()
        children.append(userlistCoordinator)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
    
}
