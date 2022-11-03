//
//  SceneDelegate.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 27/10/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appCoordinator: AppCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
#if DEBUG
        if ProcessInfo.processInfo.environment["runningTests"] != nil {
            return
        }
#endif
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        UINavigationBar.applyDefaultAppearance()
        let window = UIWindow(windowScene: windowScene)
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}

