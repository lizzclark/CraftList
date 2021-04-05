//
//  DataStore.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation
import CoreData
import Combine

enum DataStoreError: Error {
    case fetching, deleting, adding, updating
}

protocol DataStoreProtocol {
    func projectsPublisher() -> AnyPublisher<[ProjectData], DataStoreError>
    func fetchProject(id: UUID, completion: (Result<ProjectData, DataStoreError>) -> Void)
    func add(projectData: AddProjectData, completion: (Result<UUID, DataStoreError>) -> Void)
    func deleteProject(id: UUID, completion: (Result<String, DataStoreError>) -> Void)
    func updateProjectName(id: UUID, name: String, completion: (Result<String, DataStoreError>) -> Void)
    func updateProjectDateStarted(id: UUID, date: Date, completion: (Result<Date, DataStoreError>) -> Void)
    func updateProjectDateFinished(id: UUID, date: Date, completion: (Result<Date, DataStoreError>) -> Void)
}

class DataStore: NSObject, DataStoreProtocol {
    static let shared: DataStore = DataStore()
    
    private enum Keys {
        static let name = "name"
        static let dateStarted = "dateStarted"
        static let dateFinished = "dateFinished"
    }
    
    private var projects = CurrentValueSubject<[ProjectData], DataStoreError>([])
    
    private lazy var projectFetchRequest: NSFetchRequest<Project> = {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateStarted, ascending: false)]
        return request
    }()
    
    private var projectFetchController: NSFetchedResultsController<Project>?
    private let managedObjectContext: NSManagedObjectContext
    private let transformer: DataTransformer
    
    init(managedObjectContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext,
         transformer: DataTransformer = DataTransformer()) {
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
            projects.send(completion: .failure(DataStoreError.fetching))
        }
    }
    
    func projectsPublisher() -> AnyPublisher<[ProjectData], DataStoreError> {
        return projects.eraseToAnyPublisher()
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

extension DataStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let projects = controller.fetchedObjects as? [Project] else { return }
        self.projects.value = transformer.projectData(from: projects)
    }
}
