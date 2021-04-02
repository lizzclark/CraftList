//
//  ContentView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI
import CoreData

struct ProjectListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowingAddProjectView = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.dateStarted, ascending: false)],
        animation: .default)
    private var projects: FetchedResults<Project>
    
    var body: some View {
        VStack {
            Button("Add a new project") {
                isShowingAddProjectView = true
            }
            List {
                ForEach(projects) { project in
                    ProjectListItemView(viewModel: ProjectListItemViewModel(project))
                }
                .onDelete(perform: deleteItems)
            }
        }
        .sheet(isPresented: $isShowingAddProjectView, content: {
            AddProjectView()
                .environment(\.managedObjectContext, self.viewContext)
        })
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { projects[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
