//
//  CraftListApp.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

@main
struct CraftListApp: App {
    var body: some Scene {
        WindowGroup {
            ProjectListView(viewModel: ProjectListViewModel())
        }
    }
}
