//
//  ProjectDetailsView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

struct ProjectDetailsView: View {
    let viewModel: ProjectDetailsViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name)
            HStack {
                Text(viewModel.dateStartedLabel)
                Spacer()
                Text(viewModel.dateStarted)
            }
            if let dateFinished = viewModel.dateFinished {
                HStack {
                    Text(viewModel.dateFinishedLabel)
                    Spacer()
                    Text(dateFinished)
                }
            }
            Spacer()
        }
        .navigationBarTitle(viewModel.name, displayMode: .inline)
    }
}

struct ProjectDetailsView_Previews: PreviewProvider {
    static let exampleViewModel: ProjectDetailsViewModel = {
        ProjectDetailsViewModel(name: "Stripy knitted beanie", dateStarted: "Monday 3rd October 2021", dateFinished: nil)
    }()
    static var previews: some View {
        ProjectDetailsView(viewModel: exampleViewModel)
    }
}
