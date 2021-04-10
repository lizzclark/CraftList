//
//  ProjectListView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

struct ProjectListView: View {
    @ObservedObject private var viewModel: ProjectListViewModel
        
    @State var isShowingAddProjectView = false
    
    init(viewModel: ProjectListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            view(for: viewModel.projects)
                .onAppear(perform: viewModel.fetchProjects)
                .navigationBarTitle(viewModel.navBarTitle, displayMode: .inline)
                .navigationBarItems(trailing: barButtonItem)
        }
        .sheet(isPresented: $isShowingAddProjectView) {
            AddProjectView(viewModel: AddProjectViewModel(onDismiss: {
                viewModel.fetchProjects()
            }))
        }
    }
    
    @ViewBuilder private func view(for projects: [ProjectListViewModel.Project]) -> some View {
        if projects.count > 0 {
            renderProjectList()
        } else {
            Text(viewModel.loadingText)
        }
    }
    
    @ViewBuilder private func renderProjectList() -> some View {
        List {
            ForEach(viewModel.projects, id: \.id) { project in
                NavigationLink(destination: ProjectDetailsView(viewModel: ProjectDetailsViewModel(id: project.id))) {
                    ProjectListItemView(viewModel: ProjectListItemViewModel(name: project.name, image: project.image, dateStarted: project.dateStarted, dateFinished: project.dateFinished))
                }
            }
            .onDelete { offsets in
                withAnimation {
                    viewModel.deleteItems(offsets: offsets)
                }
            }
        }
    }
    
    @ViewBuilder private var barButtonItem: some View {
        Button(action: {
            isShowingAddProjectView = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(viewModel: ProjectListViewModel())
    }
}
