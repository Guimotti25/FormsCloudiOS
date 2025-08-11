//
//  EntryListViewModel.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 11/08/25.
//


import SwiftUI
import SwiftData

@MainActor
class EntryListViewModel: ObservableObject {
        
    @Published var submissions: [FormSubmission] = []
    @Published var submissionToDelete: FormSubmission? = nil
    @Published var isAddingNewEntry = false
        
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
        
    func setSubmissionToDelete(_ submission: FormSubmission?) {
        self.submissionToDelete = submission
    }
    
    func deleteSubmission() {
        if let submission = submissionToDelete {
            modelContext.delete(submission)
        }
        self.submissionToDelete = nil
    }
    
    func addEntryButtonTapped() {
        isAddingNewEntry = true
    }
}
