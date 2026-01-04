//
//  LifeOSApp.swift
//  LifeOS
//
//  Created by Batuhan Sencer on 1/3/26.
//

import SwiftUI

@main
struct LifeOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
