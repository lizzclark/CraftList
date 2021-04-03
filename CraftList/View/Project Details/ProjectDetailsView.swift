//
//  ProjectDetailsView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

struct ProjectDetailsView: View {
    let viewModel: ProjectDetailsViewModel
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if let data = viewModel.project {
                titleView(data.name)
                dateStartedView(data.dateStartedText)
                dateFinishedView(data.dateFinishedText)
                Spacer()
            }
        }
        .padding()
        .navigationBarTitle(viewModel.project?.name ?? "", displayMode: .inline)
        .navigationBarItems(trailing: deleteButton)
    }
    
    private var deleteButton: some View {
        Button(action: {
            print("delete project")
        }) {
            Image(systemName: "trash.fill")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
    
    private func titleView(_ title: String) -> some View {
        HStack(spacing: 16) {
            Button(action: {
                print("edit name")
            }) {
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.title)
                Image(systemName: "square.and.pencil")
            }
        }
    }
    
    private func dateStartedView(_ dateStartedText: String) -> some View {
        HStack {
            VStack {
                HStack {
                    Text(viewModel.dateStartedLabel)
                    Spacer()
                    Text(dateStartedText)
                }
                HStack {
                    Spacer()
                    Button(viewModel.editLabel) {
                        print("edit date started")
                    }
                }
            }
        }
    }
    
    private func dateFinishedView(_ dateFinishedText: String?) -> some View {
        VStack {
            HStack {
                Text(viewModel.dateFinishedLabel)
                Spacer()
                if let dateFinished = dateFinishedText {
                    Text(dateFinished)
                } else {
                    Text(viewModel.wipLabel)
                }
            }
            HStack {
                Spacer()
                Button(viewModel.editLabel) {
                    print("edit date finished")
                }
            }
        }
    }
}

struct ProjectDetailsView_Previews: PreviewProvider {
    static let exampleViewModel: ProjectDetailsViewModel = {
        ProjectDetailsViewModel(id: UUID())
    }()
    static var previews: some View {
        ProjectDetailsView(viewModel: exampleViewModel)
    }
}
