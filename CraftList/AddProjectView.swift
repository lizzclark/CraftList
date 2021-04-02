//
//  AddProjectView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

struct AddProjectView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var name = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Project name", text: $name)
                }
                Section {
                    Button("Save") {
                        let newProject = Item(context: self.viewContext)
                        newProject.name = name
                        try? self.viewContext.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationBarTitle("Add a Project")
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView()
    }
}
