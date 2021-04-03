//
//  ProjectListViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI
import Combine

class ProjectListViewModel: ObservableObject {
    
    struct Project: Hashable {
        let name: String
        let dateStarted: Date
        let dateFinished: Date?
    }
    
    let navBarTitle = "Projects"
    
    @Published var projects: [Project] = []
    
    private let service: ProjectService
    private var cancellable: AnyCancellable?
    
    init(service: ProjectService = ProjectService()) {
        self.service = service
        subscribeToProjects()
    }
    
    private func subscribeToProjects() {
        cancellable = service.projects()
            .sink { [weak self] projects in
                guard let self = self else { return }
                self.projects = self.viewModels(from: projects)
            }
    }
    
    func viewModels(from projects: [ProjectModel]) -> [Project] {
        return projects.map { Project(name: $0.name, dateStarted: $0.dateStarted, dateFinished: $0.dateFinished) }
    }
    
//    func deleteProject(project: NSManagedObject, from context: NSManagedObjectContext) {
//        context.delete(project)
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
}
