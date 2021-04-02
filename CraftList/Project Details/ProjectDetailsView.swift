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
        NavigationView {
            Text("Details of \(viewModel.name)")
        }
        .navigationBarTitle(viewModel.name)
    }
}

struct ProjectDetailsView_Previews: PreviewProvider {
    static let exampleViewModel: ProjectDetailsViewModel = {
        ProjectDetailsViewModel(name: "Stripy knitted beanie", dateStarted: Date())
    }()
    static var previews: some View {
        ProjectDetailsView(viewModel: exampleViewModel)
    }
}
