//
//  DataStore.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation
import CoreData
import Combine

class DataStore: NSObject {
    static let shared: DataStore = DataStore()
    
    private var projects = CurrentValueSubject<[ProjectData], Never>([])
    
    private lazy var projectFetchRequest: NSFetchRequest<Project> = {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateStarted, ascending: false)]
        return request
    }()
    
    private var projectFetchController: NSFetchedResultsController<Project>?
    private let managedObjectContext: NSManagedObjectContext
    private let transformer: ProjectTransformer
    
    init(managedObjectContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext,
         transformer: ProjectTransformer = ProjectTransformer()) {
        self.managedObjectContext = managedObjectContext
        self.transformer = transformer
        super.init()
        setUpAndFetch()
    }
    
    private func setUpAndFetch() {
        projectFetchController = NSFetchedResultsController(fetchRequest: projectFetchRequest,
                                                            managedObjectContext: managedObjectContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
        projectFetchController?.delegate = self
        do {
            try projectFetchController?.performFetch()
            projects.value = transformer.projectData(from: projectFetchController?.fetchedObjects)
        } catch {
            fatalError("failed to fetch data")
        }
    }
    
    func fetchProjects() -> AnyPublisher<[ProjectData], Never> {
        return projects.eraseToAnyPublisher()
    }
    
    func add(projectData: ProjectData, completion: () -> Void) {
        let newProject = Project(context: managedObjectContext)
        newProject.name = projectData.name
        newProject.dateStarted = projectData.dateStarted
        if let dateFinished = projectData.dateFinished {
            newProject.dateFinished = dateFinished
        }
        do {
            try managedObjectContext.save()
            completion()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension DataStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let projects = controller.fetchedObjects as? [Project] else { return }
        self.projects.value = transformer.projectData(from: projects)
    }
}
