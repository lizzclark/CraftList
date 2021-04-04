//
//  EditDateViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 04/04/2021.
//

import Foundation
import Combine

class EditDateViewModel: ObservableObject {
    @Published var date: Date

    let title: String = "Edit Date Started"
    let dateStartedLabel: String = "Date Started"
    let saveButtonLabel: String = "Save"

    private let projectId: UUID
    private let service: ProjectService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(projectId: UUID,
         date: Date,
         service: ProjectService = ProjectService()) {
        self.projectId = projectId
        self.date = date
        self.service = service
    }
    
    func save(_ completion: @escaping () -> Void) {
        service.updateProjectDateStarted(id: projectId, date: date)
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
