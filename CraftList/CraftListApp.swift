//
//  CraftListApp.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

@main
struct CraftListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ProjectListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
