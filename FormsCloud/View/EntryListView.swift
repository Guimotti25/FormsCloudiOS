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
    @Query private var submissions: [FormSubmission]
    @State private var isAddingNewEntry = false
    @State private var submissionToDelete: FormSubmission?
    @Environment(\.modelContext) private var modelContext

    init(form: FormModel) {
        self.form = form
        let formID = form.id
        let predicate = #Predicate<FormSubmission> { submission in
            submission.parentFormUUID == formID
        }
        self._submissions = Query(filter: predicate, sort: \.createdAt, order: .reverse)
    }

    var body: some View {
        Group {
            if submissions.isEmpty {
                ContentUnavailableView("No Forms",
                                       systemImage: "doc.text.magnifyingglass",
                                       description: Text("Tap on '+' to add the first entry for this form."))
            } else {
                List {
                    ForEach(submissions) { submission in
                        NavigationLink(destination: SubmissionDetailView(submission: submission, form: self.form)) {
                            
                            SubmissionCardView(submission: submission)
                            .onLongPressGesture {
                                 self.submissionToDelete = submission
                             }
                        }
                    }
                }
            }
        }
        .navigationTitle(form.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { isAddingNewEntry = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddingNewEntry) {
            FormDetailView(form: self.form)
        }
        .alert("Confirm", isPresented: .constant(submissionToDelete != nil), actions: {
              Button("Delete", role: .destructive) {
                  if let submission = submissionToDelete {
                      delete(submission: submission)
                  }
              }
              Button("Cancel", role: .cancel) {
                  submissionToDelete = nil
              }
          }, message: {
              Text("Are you sure you want to delete this form?")
          })    }
    
    private func delete(submission: FormSubmission) {
          modelContext.delete(submission)
        submissionToDelete = nil
      }
}

#Preview {
    let sampleForm = load("all-fields.json") as FormModel
    return NavigationStack {
        EntryListView(form: sampleForm)
            .modelContainer(for: FormSubmission.self, inMemory: true)
    }
}


func load<T: Decodable>(_ filename: String) -> T {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Cant load the \(filename) in main bundle")
    }
    
    guard let data = try? Data(contentsOf: file) else {
        fatalError("Cant load the \(filename) in bundle.")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Cant decode the\(filename) like \(T.self):\n\(error)")
    }
}
