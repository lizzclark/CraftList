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
            List {
                ForEach(projects) { project in
                    NavigationLink(destination: detailsView(from: project)) {
                        ProjectListItemView(viewModel: ProjectListItemViewModel(project))
                    }
                }
                .onDelete { offsets in
                    withAnimation {
                        deleteItems(offsets: offsets)
                    }
                }
            }
            .navigationTitle(viewModel.navBarTitle)
            .navigationBarItems(trailing: barButtonItem)
        }
        .sheet(isPresented: $isShowingAddProjectView) {
            AddProjectView()
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
    
    @ViewBuilder private var barButtonItem: some View {
        Button(action: {
            isShowingAddProjectView = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
        }
    }
    
    private func detailsView(from project: Project) -> some View {
        ProjectDetailsView(viewModel: .init(project))
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
