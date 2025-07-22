//
//  BookTrackerApp.swift
//  BookTracker
//
//  Created by Rushi on 22/07/25.
//

import SwiftUI

@main
struct BookTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
