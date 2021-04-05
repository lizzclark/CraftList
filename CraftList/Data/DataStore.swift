//
//  DataStore.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation
import CoreData

enum DataStoreError: Error {
    case fetching, deleting, adding, updating
}

protocol DataStoreProtocol {
    func fetchProjects(completion: (Result<[ProjectData], DataStoreError>) -> Void)
    func fetchProject(id: UUID, completion: (Result<ProjectData, DataStoreError>) -> Void)
    func add(projectData: AddProjectData, completion: (Result<UUID, DataStoreError>) -> Void)
    func deleteProject(id: UUID, completion: (Result<String, DataStoreError>) -> Void)
    func updateProjectName(id: UUID, name: String, completion: (Result<String, DataStoreError>) -> Void)
    func updateProjectDateStarted(id: UUID, date: Date, completion: (Result<Date, DataStoreError>) -> Void)
    func updateProjectDateFinished(id: UUID, date: Date, completion: (Result<Date, DataStoreError>) -> Void)
}

class DataStore: DataStoreProtocol {
    static let shared: DataStore = DataStore()
    
    private enum Keys {
        static let name = "name"
        static let dateStarted = "dateStarted"
        static let dateFinished = "dateFinished"
    }

    private lazy var projectFetchRequest: NSFetchRequest<Project> = {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateStarted, ascending: false)]
        return request
    }()
    
    private let managedObjectContext: NSManagedObjectContext
    private let transformer: DataTransformer
    
    init(managedObjectContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext,
         transformer: DataTransformer = DataTransformer()) {
        self.managedObjectContext = managedObjectContext
        self.transformer = transformer
    }
        
    func fetchProjects(completion: (Result<[ProjectData], DataStoreError>) -> Void) {
        let fetchController = NSFetchedResultsController(fetchRequest: projectFetchRequest,
                                                            managedObjectContext: managedObjectContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
        do {
            try fetchController.performFetch()
            let fetchedProjects = transformer.projectData(from: fetchController.fetchedObjects)
            completion(.success(fetchedProjects))
        } catch {
            completion(.failure(.fetching))
        }
    }
        
    func fetchProject(id: UUID, completion: (Result<ProjectData, DataStoreError>) -> Void) {
        let fetchController = makeFetchController(for: id)
        do {
            try fetchController.performFetch()
            guard let project = transformer.projectData(fetchController.fetchedObjects?.first) else { throw DataStoreError.fetching }
            completion(.success(project))
        } catch {
            completion(.failure(DataStoreError.fetching))
        }
    }
    
    func add(projectData: AddProjectData, completion: (Result<UUID, DataStoreError>) -> Void) {
        let newProject = Project(context: managedObjectContext)
        let id = UUID()
        newProject.id = id
        newProject.name = projectData.name
        if let image = projectData.imageData {
            newProject.image = image
        }
        newProject.dateStarted = projectData.dateStarted
        if let dateFinished = projectData.dateFinished {
            newProject.dateFinished = dateFinished
        }
        do {
            try managedObjectContext.save()
            completion(.success(id))
        } catch {
            completion(.failure(DataStoreError.adding))
        }
    }
    
    func deleteProject(id: UUID, completion: (Result<String, DataStoreError>) -> Void) {
        let deleteController = makeFetchController(for: id)
        do {
            try deleteController.performFetch()
            guard let object = deleteController.fetchedObjects?.first, let name = object.name else { throw DataStoreError.deleting }
            managedObjectContext.delete(object)
            try managedObjectContext.save()
            completion(.success(name))
        } catch {
            completion(.failure(DataStoreError.deleting))
        }
    }
    
    func updateProjectName(id: UUID, name: String, completion: (Result<String, DataStoreError>) -> Void) {
        let fetchController = makeFetchController(for: id)
        do {
            try fetchController.performFetch()
            guard let object = fetchController.fetchedObjects?.first else { throw DataStoreError.fetching }
            object.setValue(name, forKey: Keys.name)
            try managedObjectContext.save()
            guard let newName = object.name else { throw DataStoreError.updating }
            completion(.success(newName))
        } catch {
            completion(.failure(DataStoreError.updating))
        }
    }
    
    func updateProjectDateStarted(id: UUID, date: Date, completion: (Result<Date, DataStoreError>) -> Void) {
        let fetchController = makeFetchController(for: id)
        do {
            try fetchController.performFetch()
            guard let object = fetchController.fetchedObjects?.first else { throw DataStoreError.fetching }
            object.setValue(date, forKey: Keys.dateStarted)
            try managedObjectContext.save()
            guard let newDate = object.dateStarted else { throw DataStoreError.updating }
            completion(.success(newDate))
        } catch {
            completion(.failure(DataStoreError.updating))
        }
    }
    
    func updateProjectDateFinished(id: UUID, date: Date, completion: (Result<Date, DataStoreError>) -> Void) {
        let fetchController = makeFetchController(for: id)
        do {
            try fetchController.performFetch()
            guard let object = fetchController.fetchedObjects?.first else { throw DataStoreError.fetching }
            object.setValue(date, forKey: Keys.dateFinished)
            try managedObjectContext.save()
            guard let newDate = object.dateFinished else { throw DataStoreError.updating }
            completion(.success(newDate))
        } catch {
            completion(.failure(DataStoreError.updating))
        }
    }

        
    private func makeFetchController(for id: UUID) -> NSFetchedResultsController<Project> {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateStarted, ascending: false)]
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: managedObjectContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
}
