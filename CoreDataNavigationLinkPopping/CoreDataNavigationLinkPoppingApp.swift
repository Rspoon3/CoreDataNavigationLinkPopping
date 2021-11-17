//
//  CoreDataNavigationLinkPoppingApp.swift
//  CoreDataNavigationLinkPopping
//
//  Created by Richard Witherspoon on 11/17/21.
//

import SwiftUI

@main
struct CoreDataNavigationLinkPoppingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
