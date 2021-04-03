//
//  ProjectListView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

struct ProjectListView: View {
    @ObservedObject private var viewModel = ProjectListViewModel()
        
    @State var isShowingAddProjectView = false
    
    var body: some View {
        NavigationView {
            renderProjectList()
                .navigationBarTitle(viewModel.navBarTitle, displayMode: .inline)
                .navigationBarItems(trailing: barButtonItem)
        }
        .sheet(isPresented: $isShowingAddProjectView) {
            AddProjectView()
        }
    }
    
    private func renderProjectList() -> some View {
        return List {
            ForEach(viewModel.projects, id: \.self) { project in
                NavigationLink(destination: ProjectDetailsView(viewModel: ProjectDetailsViewModel(name: project.name, dateStarted: "date started", dateFinished: "date finished"))) {
                    ProjectListItemView(viewModel: ProjectListItemViewModel(name: project.name, dateStarted: project.dateStarted, dateFinished: project.dateFinished))
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
        ProjectListView()
    }
}