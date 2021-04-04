//
//  EditDateView.swift
//  CraftList
//
//  Created by Lizz Clark on 04/04/2021.
//

import SwiftUI

struct EditDateView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: EditDateViewModel
    
    init(viewModel: EditDateViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker(selection: $viewModel.date, in: ...Date(), displayedComponents: .date) {
                        Text(viewModel.field.description)
                    }
                }
                Section {
                    Button(viewModel.saveButtonLabel) {
                        viewModel.save {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationBarTitle(viewModel.field.title, displayMode: .inline)
        }
    }
}

struct EditDateView_Previews: PreviewProvider {
    static var previews: some View {
        EditDateView(viewModel: EditDateViewModel(.dateStarted, projectId: UUID(), date: Date()))
    }
}
