//
//  ProjectDetailsView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

struct ProjectDetailsView: View {
    @State private var isShowingDeleteAlert = false
    @State private var activeEditSheet: EditSheet? = nil
    @ObservedObject var viewModel: ProjectDetailsViewModel
    
    enum EditSheet: Identifiable {
        var id: Int {
            hashValue
        }
        case none, name, dateStarted, dateFinished
    }
    
    @State private var name = ""
    
    var body: some View {
        Group {
            if let project = viewModel.project {
                projectDetails(for: project)
                    .padding()
                    .navigationBarTitle(project.name, displayMode: .inline)
                    .navigationBarItems(trailing: deleteButton)
            } else {
                Text(viewModel.emptyStateLabel)
                    .padding()
            }
        }
        .onAppear(perform: viewModel.fetchProject)
    }
        
    private func projectDetails(for project: ProjectDetailsViewModel.Data) -> some View {
        VStack(alignment: .center, spacing: 16) {
            nameView(project.name)
            if let image = project.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            dateStartedView(project.dateStartedText)
            dateFinishedView(project.dateFinishedText)
            Spacer()
        }
        .alert(isPresented: $isShowingDeleteAlert, content: {
            Alert(title: Text(viewModel.deleteTitle),
                  message: Text(viewModel.deleteMessage),
                  primaryButton: .destructive(Text(viewModel.deleteLabel), action: viewModel.deleteProject),
                  secondaryButton: .cancel(Text(viewModel.cancelLabel)))
        })
        .sheet(item: $activeEditSheet) { item in
            switch item {
            case .name:
                EditNameView(viewModel: .init(projectId: viewModel.id, name: project.name))
            case .dateStarted:
                EditDateView(viewModel: .init(.dateStarted, projectId: viewModel.id, date: project.dateStarted))
            case .dateFinished:
                EditDateView(viewModel: .init(.dateFinished, projectId: viewModel.id, date: project.dateFinished))
            case .none:
                EmptyView()
            }
        }
    }
    
    private var deleteButton: some View {
        Button(action: { isShowingDeleteAlert.toggle() }) {
            Image(systemName: "trash.fill")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
        
    private func nameView(_ name: String) -> some View {
        HStack(spacing: 16) {
            Button(action: { activeEditSheet = .name }) {
                Text(name)
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
                    Button(viewModel.editLabel, action: { activeEditSheet = .dateStarted })
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
                Button(viewModel.editLabel, action: { activeEditSheet = .dateFinished })
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
