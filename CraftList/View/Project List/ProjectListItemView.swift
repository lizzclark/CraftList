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
            Text(viewModel.dateStartedText)
            if let dateFinishedText = viewModel.dateFinishedText {
                Text(dateFinishedText)
            }
        }
    }
}

struct ProjectListItemView_Previews: PreviewProvider {
    static let exampleViewModel: ProjectListItemViewModel = {
        .init(name: "Macrame wall hanging", dateStarted: Date(), dateFinished: Date())
    }()
    static var previews: some View {
        ProjectListItemView(viewModel: exampleViewModel)
    }
}
