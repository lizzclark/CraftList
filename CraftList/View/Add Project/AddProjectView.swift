//
//  AddProjectView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

struct AddProjectView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = AddProjectViewModel()
    
    @State var isShowingImagePicker = false
    @State var image: UIImage?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(viewModel.projectNameLabel, text: $viewModel.name)
                }
                Section {
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    Button(viewModel.selectImageLabel) {
                        isShowingImagePicker = true
                    }
                }
                Section {
                    DatePicker(selection: $viewModel.dateStarted, in: ...Date(), displayedComponents: .date) {
                        Text(viewModel.dateStartedLabel)
                    }
                    dateFinishedView()
                }
                Section {
                    Button(viewModel.saveLabel) {
                        viewModel.save {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationBarTitle(viewModel.title)
            .sheet(isPresented: $isShowingImagePicker) { 
                ImagePicker(selectedImage: self.$image)
            }
        }
    }
    
    @ViewBuilder private func dateFinishedView() -> some View {
        VStack(alignment: .leading) {
            Text(viewModel.statusLabel)
            Picker(selection: $viewModel.isFinished, label: Text(viewModel.statusLabel)) {
                Text(viewModel.wipLabel).tag(false)
                Text(viewModel.finishedLabel).tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            if viewModel.isFinished {
                DatePicker(selection: $viewModel.dateFinishedFieldValue, in: ...Date(), displayedComponents: .date) {
                    Text(viewModel.dateFinishedLabel)
                }
            }
        }
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView()
    }
}
