//
//  ProjectDetailsView.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI

struct ProjectDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
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
        body(for: viewModel.project)
            .onAppear(perform: viewModel.fetchProject)
    }
    
    @ViewBuilder private func body(for project: ProjectDetailsViewModel.Data?) -> some View {
        ScrollView {
            Group {
                if let data = project {
                    projectDetails(for: data)
                        .padding()
                } else {
                    Text(viewModel.emptyStateLabel)
                        .padding()
                }
            }
            .navigationBarTitle(project?.name ?? "Project", displayMode: .inline)
            .navigationBarItems(trailing: deleteButton)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 14, height: 24)
                    .aspectRatio(contentMode: .fit)
            }))
        }
    }
        
    private func projectDetails(for project: ProjectDetailsViewModel.Data) -> some View {
        VStack(alignment: .center, spacing: 16) {
            nameView(project.name)
            LoadingImage(publisher: project.imagePublisher)
                .clipShape(RoundedRectangle(cornerRadius: 12))
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
                EditNameView(viewModel: .init(projectId: viewModel.id, name: project.name) {
                    viewModel.fetchProject()
                })
            case .dateStarted:
                EditDateView(viewModel: .init(.dateStarted, projectId: viewModel.id, date: project.dateStarted) {
                    viewModel.fetchProject()
                })
            case .dateFinished:
                EditDateView(viewModel: .init(.dateFinished, projectId: viewModel.id, date: project.dateFinished) {
                    viewModel.fetchProject()
                })
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
