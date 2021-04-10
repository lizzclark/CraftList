//
//  ProjectListItemView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI
import Combine

struct ProjectListItemView: View {
    private let viewModel: ProjectListItemViewModel
    
    init(viewModel: ProjectListItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name)
                .font(.headline)
            Color.clear
                .aspectRatio(1.5, contentMode: .fill)
                .overlay(imageView)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(viewModel.dateStartedText)
            if let dateFinishedText = viewModel.dateFinishedText {
                Text(dateFinishedText)
            }
        }
    }
    
    private var imageView: some View {
        LoadingImage(publisher: viewModel.imagePublisher)
    }
}

struct ProjectListItemView_Previews: PreviewProvider {
    static let exampleViewModel: ProjectListItemViewModel = {
        .init(id: UUID(), name: "Macrame wall hanging", imagePublisher: Just(UIImage(systemName: "trash.fill")!).eraseToAnyPublisher(), dateStarted: Date(), dateFinished: Date())
    }()
    static var previews: some View {
        ProjectListItemView(viewModel: exampleViewModel)
    }
}
