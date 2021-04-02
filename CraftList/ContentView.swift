//
//  ContentView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowingAddProjectView = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.dateStarted, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Project>
    
    var body: some View {
        VStack {
            Button("Add a new project") {
                isShowingAddProjectView = true
            }
            List {
                ForEach(items) { item in
                    projectView(from: item)
                }
                .onDelete(perform: deleteItems)
            }
        }
        .sheet(isPresented: $isShowingAddProjectView, content: {
            AddProjectView()
                .environment(\.managedObjectContext, self.viewContext)
        })
    }
    
    private func projectView(from project: Project) -> some View {
        VStack(alignment: .leading) {
            if let name = project.name {
                Text(name)
            }
            if let dateStarted = dateText(from: project) {
                Text(dateStarted)
            }
        }
    }
    
    private func dateText(from project: Project) -> String? {
        guard let date = project.dateStarted else { return nil }
        return projectFormatter.string(from: date)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
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

private let projectFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
