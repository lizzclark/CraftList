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
            titleView
            dateStartedView
            dateFinishedView
            Spacer()
        }
        .padding()
        .navigationBarTitle(viewModel.name, displayMode: .inline)
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
    
    private var titleView: some View {
        HStack(spacing: 16) {
            Button(action: {
                print("edit name")
            }) {
                Text(viewModel.name)
                    .multilineTextAlignment(.center)
                    .font(.title)
                Image(systemName: "square.and.pencil")
            }
        }
    }
    
    private var dateStartedView: some View {
        HStack {
            VStack {
                HStack {
                    Text(viewModel.dateStartedLabel)
                    Spacer()
                    Text(viewModel.dateStarted)
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
    
    private var dateFinishedView: some View {
        VStack {
            HStack {
                Text(viewModel.dateFinishedLabel)
                Spacer()
                if let dateFinished = viewModel.dateFinished {
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
        ProjectDetailsViewModel(name: "Stripy knitted beanie", dateStarted: "Monday 3rd October 2021", dateFinished: nil)
    }()
    static var previews: some View {
        ProjectDetailsView(viewModel: exampleViewModel)
    }
}
