//
//  SceneDelegate.swift
//  PlacementTestIOS3
//
//  Created by Yiğit Atik on 2.12.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        // Root VC is our Placement demo
        let rootViewController = ViewController()

        window.rootViewController = rootViewController
        self.window = window
        window.makeKeyAndVisible()
    }

    // The rest of these are optional / unused in this simple demo
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

