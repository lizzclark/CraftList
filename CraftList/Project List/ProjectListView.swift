//
//  ContentView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI
import CoreData

struct ProjectListView: View {
    private let viewModel = ProjectListViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowingAddProjectView = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.dateStarted, ascending: false)],
        animation: .default
    )
    private var projects: FetchedResults<Project>
    
    var body: some View {
        NavigationView {
            renderList(from: projects)
                .navigationBarTitle(viewModel.navBarTitle, displayMode: .inline)
                .navigationBarItems(trailing: barButtonItem)
        }
        .sheet(isPresented: $isShowingAddProjectView) {
            AddProjectView()
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
    
    private func renderList(from projects: FetchedResults<Project>) -> some View {
        let transformedProjects = projects.compactMap { ProjectViewModel($0) }
        return List {
            ForEach(transformedProjects, id: \.self) { viewModel in
                renderListItem(from: viewModel)
            }
            .onDelete { offsets in
                withAnimation {
                    deleteItems(offsets: offsets)
                }
            }
        }
    }
    
    private func renderListItem(from projectViewModel: ProjectViewModel) -> some View {
        NavigationLink(destination: ProjectDetailsView(viewModel: projectViewModel.detailsViewModel)) {
            ProjectListItemView(viewModel: projectViewModel.listItemViewModel)
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
    
    private func deleteItems(offsets: IndexSet) {
        offsets.map { projects[$0] }.forEach({viewModel.deleteProject(project: $0, from: self.viewContext)})
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
