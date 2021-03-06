//
//  AddProjectViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation
import Combine
import UIKit

class AddProjectViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var image: UIImage? = nil
    @Published var dateStarted: Date = Date()
    @Published var isFinished = false
    @Published var dateFinishedFieldValue: Date = Date()
    
    let title = "Add a Project"
    let projectNameLabel = "Project Name"
    let selectImageLabel = "Select Image"
    let dateStartedLabel = "Date Started"
    let statusLabel = "Status"
    let wipLabel = "WIP"
    let finishedLabel = "Finished"
    let dateFinishedLabel = "Date Finished"
    let saveLabel = "Save"
    
    private let service: ProjectServiceProtocol
    let onDismiss: () -> Void
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ProjectServiceProtocol = ProjectService(),
         onDismiss: @escaping () -> Void) {
        self.service = service
        self.onDismiss = onDismiss
    }
    
    func save(_ completion: @escaping () -> Void) {
        var finishDate: Date?
        if isFinished {
            finishDate = dateFinishedFieldValue
        }
        service.addProject(name: name, imageData: image?.pngData(), dateStarted: dateStarted, dateFinished: finishDate)
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
