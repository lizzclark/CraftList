//
//  ProjectListItemView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

struct ProjectListItemView: View {
    private let viewModel: ProjectListItemViewModel
    
    init(viewModel: ProjectListItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name)
                .font(.headline)
            if let image = viewModel.image {
                Color.clear
                    .aspectRatio(1.5, contentMode: .fill)
                    .overlay(imageView(image))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            Text(viewModel.dateStartedText)
            if let dateFinishedText = viewModel.dateFinishedText {
                Text(dateFinishedText)
            }
        }
    }
    
    private func imageView(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct ProjectListItemView_Previews: PreviewProvider {
    static let exampleViewModel: ProjectListItemViewModel = {
        .init(name: "Macrame wall hanging", image: Image(systemName: "cloud.sun"), dateStarted: Date(), dateFinished: Date())
    }()
    static var previews: some View {
        ProjectListItemView(viewModel: exampleViewModel)
    }
}
