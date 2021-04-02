//
//  AddProjectViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation
import CoreData

class AddProjectViewModel: ObservableObject {
    let title = "Add a Project"
    let projectNameLabel = "Project Name"
    let dateStartedLabel = "Date Started"
    let saveLabel = "Save"
    
    func save(_ project: ProjectViewModel, in context: NSManagedObjectContext, completion: () -> Void) {
        let newProject = Project(context: context)
        newProject.name = project.name
        newProject.dateStarted = project.dateStarted
        do {
            try context.save()
            completion()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
