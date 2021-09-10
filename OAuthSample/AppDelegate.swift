//
//  AppDelegate.swift
//  OAuthSample
//
//  Created by Masato Takamura on 2021/09/10.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var welcomeViewController: WelcomeViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let welcomeVC = UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController() as! WelcomeViewController
        self.welcomeViewController = welcomeVC
        let nav = UINavigationController(rootViewController: welcomeVC)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.makeKeyAndVisible()

        self.window = window
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard
            let welcomeVC = self.welcomeViewController
        else {
            return true
        }
        welcomeVC.openUrl(url)
        return true
    }
}
