//
//  EntryListView.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 09/08/25.
//

import SwiftUI
import SwiftData

struct EntryListView: View {
 
    let form: FormModel
    @StateObject private var viewModel: EntryListViewModel
    @Query private var submissions: [FormSubmission]
    init(form: FormModel, modelContext: ModelContext) {
        self.form = form
        
        let formID = form.id
        let predicate = #Predicate<FormSubmission> { $0.parentFormUUID == formID }
        self._submissions = Query(filter: predicate, sort: \.createdAt, order: .reverse)
        
        _viewModel = StateObject(wrappedValue: EntryListViewModel(modelContext: modelContext))
    }

    var body: some View {
        Group {
            if viewModel.submissions.isEmpty {
                ContentUnavailableView(
                    "No Entries",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text("Tap on '+' to add the first entry for this form.")
                )
            } else {
                List {
                    ForEach(viewModel.submissions) { submission in
                        NavigationLink(destination: SubmissionDetailView(submission: submission, form: self.form)) {
                            SubmissionCardView(submission: submission)
                                .onLongPressGesture {
                                    viewModel.setSubmissionToDelete(submission)
                                }
                        }
                    }
                }
            }
        }
        .navigationTitle(form.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    viewModel.addEntryButtonTapped()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.isAddingNewEntry) {
            NewFormsView(form: self.form, modelContext: viewModel.modelContext)
        }
        .alert("Confirm Deletion", isPresented: .constant(viewModel.submissionToDelete != nil)) {
            Button("Delete", role: .destructive) {
                viewModel.deleteSubmission()
            }
            Button("Cancel", role: .cancel) {
                viewModel.setSubmissionToDelete(nil)
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
        .onChange(of: submissions) {
            viewModel.submissions = submissions
        }
        .onAppear {
            viewModel.submissions = submissions
        }
    }
}
