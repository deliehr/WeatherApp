//
//  DomsWeatherAppApp.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 26.05.24.
//

import SwiftUI

@main
struct DomsWeatherAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
