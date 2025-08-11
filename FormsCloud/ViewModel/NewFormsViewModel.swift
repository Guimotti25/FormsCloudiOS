//
//  NewFormsViewModel.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 11/08/25.
//


import SwiftUI
import SwiftData

@MainActor
class NewFormsViewModel: ObservableObject {
    
    @Published var fieldValues: [String: String] = [:]
    @Published var isFormInvalid: Bool = true
    @Published var showValidationMessage = false
    @Published var validationMessage = ""
    
    private let form: FormModel
    private let modelContext: ModelContext

    init(form: FormModel, modelContext: ModelContext) {
        self.form = form
        self.modelContext = modelContext
        validateForm()
    }

    func binding(for fieldName: String) -> Binding<String> {
        return Binding(
            get: { self.fieldValues[fieldName] ?? "" },
            set: { newValue in
                self.fieldValues[fieldName] = newValue
                self.validateForm()
            }
        )
    }

    func validateForm() {
        let requiredFields = form.fields.filter { $0.required == true }
        let allRequiredFieldsAreFilled = requiredFields.allSatisfy { field in
            let value = fieldValues[field.name] ?? ""
            if field.type == "checkbox" && field.options == nil {
                return value == "true"
            }
            return !value.isEmpty
        }
        self.isFormInvalid = !allRequiredFieldsAreFilled
    }

    func saveSubmission(completion: @escaping () -> Void) {
        let newSubmission = FormSubmission(parentFormUUID: form.id, fieldValues: self.fieldValues)
        modelContext.insert(newSubmission)
        
        do {
            try modelContext.save()
            completion() 
        } catch {
            print("Can't save: \(error.localizedDescription)")
            showTemporaryMessage(text: "Error, try later")
        }
    }

    func showTemporaryMessage(text: String) {
        self.validationMessage = text
        withAnimation { self.showValidationMessage = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation { self.showValidationMessage = false }
        }
    }
}
