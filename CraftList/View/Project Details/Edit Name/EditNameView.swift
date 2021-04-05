//
//  EditNameView.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import SwiftUI
import Combine

struct EditNameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EditNameViewModel
    
    init(viewModel: EditNameViewModel) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(viewModel.projectNameLabel, text: $viewModel.name)
                }
                Section {
                    Button(viewModel.saveButtonLabel) {
                        viewModel.save {
                            self.presentationMode.wrappedValue.dismiss()
                            self.viewModel.onDismiss()
                        }
                    }
                }
            }
            .navigationBarTitle(viewModel.title, displayMode: .inline)
        }
    }
}

struct EditNameView_Previews: PreviewProvider {
    static var previews: some View {
        EditNameView(viewModel: EditNameViewModel(projectId: UUID(), name: "My project", { }))
    }
}
