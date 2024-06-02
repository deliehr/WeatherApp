//
//  DomsWeatherApp.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 26.05.24.
//

import SwiftUI
import DevTools

@main
struct DomsWeatherApp: App {
    init() {
        NetworkMonitor.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
