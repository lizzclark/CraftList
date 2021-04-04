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

    let saveButtonLabel: String = "Save"
    
    let field: Field
    private let projectId: UUID
    private let service: ProjectService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ field: Field,
         projectId: UUID,
         date: Date?,
         service: ProjectService = ProjectService()) {
        self.field = field
        self.projectId = projectId
        self.date = date ?? Date()
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

extension EditDateViewModel {
    enum Field: CustomStringConvertible {
        case dateStarted, dateFinished
        
        var description: String {
            switch self {
            case .dateStarted:
                return "Date Started"
            case .dateFinished:
                return "Date Finished"
            }
        }
        
        var title: String {
            switch self {
            case .dateStarted:
                return "Edit Date Started"
            case .dateFinished:
                return "Edit Date Finished"
            }
        }
    }
}
