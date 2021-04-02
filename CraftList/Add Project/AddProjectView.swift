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
    @State var project: ProjectViewModel = ProjectViewModel.default
    private let viewModel = AddProjectViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(viewModel.projectNameLabel, text: $project.name)
                    DatePicker(selection: $project.dateStarted, in: ...Date(), displayedComponents: .date) {
                        Text(viewModel.dateStartedLabel)
                    }
                }
                Section {
                    Button(viewModel.saveLabel) {
                        viewModel.save(project, in: self.viewContext) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
        .navigationBarTitle(viewModel.title)
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView()
    }
}
