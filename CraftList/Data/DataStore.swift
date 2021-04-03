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
    case fetching, deleting, adding
}

class DataStore: NSObject {
    static let shared: DataStore = DataStore()
    
    private var projects = CurrentValueSubject<[ProjectData], DataStoreError>([])
    
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
            guard let project = transformer.projectData(fetchController.fetchedObjects?.first) else { fatalError("why") }
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
            guard let object = deleteController.fetchedObjects?.first, let name = object.name else { fatalError() }
            managedObjectContext.delete(object)
            try managedObjectContext.save()
            completion(.success(name))
        } catch {
            completion(.failure(DataStoreError.deleting))
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
