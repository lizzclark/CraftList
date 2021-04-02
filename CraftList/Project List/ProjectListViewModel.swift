//
//  ProjectListViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation
import CoreData

struct ProjectListViewModel {
    let navBarTitle = "Projects"
    
    func deleteProject(project: NSManagedObject, from context: NSManagedObjectContext) {
        context.delete(project)
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
