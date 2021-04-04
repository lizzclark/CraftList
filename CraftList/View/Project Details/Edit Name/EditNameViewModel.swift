//
//  EditNameViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 04/04/2021.
//

import Foundation
import Combine

class EditNameViewModel: ObservableObject {
    @Published var name: String
    
    let title: String = "Edit Project Name"
    let projectNameLabel: String = "Project Name"
    let saveButtonLabel: String = "Save"
    
    private let projectId: UUID
    private let service: ProjectService
    private var cancellables = Set<AnyCancellable>()
    
    init(projectId: UUID,
         name: String,
         service: ProjectService = ProjectService()) {
        self.projectId = projectId
        self.name = name
        self.service = service
    }
    
    func save(_ completion: @escaping () -> Void) {
        service.updateProjectName(id: projectId, name: name)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    // handle error
                    break
                }
            }) { _ in
                completion()
            }
            .store(in: &cancellables)
    }
}
