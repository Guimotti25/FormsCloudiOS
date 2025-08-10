//
//  FormDetailView.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 09/08/25.
//


import SwiftUI

struct FormDetailView: View {
    let form: FormModel
    @State private var fieldValues: [String: String] = [:]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showValidationMessage = false
    @State private var validationMessage = ""

    private var isFormInvalid: Bool {
        let requiredFields = form.fields.filter { $0.required == true }

        let allRequiredFieldsAreFilled = requiredFields.allSatisfy { field in
            let value = fieldValues[field.uuid] ?? ""
            
            if field.type == "checkbox" {
                return value == "true"
            }
            
            return !value.isEmpty
        }
        
        return !allRequiredFieldsAreFilled
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(form.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if let sections = form.sections {
                    ForEach(sections, id: \.id) { section in
                        SectionView(section: section, formFields: form.fields, fieldValues: $fieldValues)
                    }
                } else {
                    ForEach(form.fields, id: \.id) { field in
                        FieldView(field: field, value: Binding(
                            get: { self.fieldValues[field.id] ?? "" },
                            set: { self.fieldValues[field.id] = $0 }
                        ))
                    }
                }
                
                Button("Save") {
                    if isFormInvalid {
                       showTemporaryMessage(text: "Fill in all required fields (*)")
                   } else {
                       saveSubmission()
                   }
                  
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .animation(.easeInOut, value: isFormInvalid)
                .cornerRadius(8)
            }
            .padding()
        }
        
           if showValidationMessage {
               Text(validationMessage)
                   .padding()
                   .background(Color.black.opacity(0.8))
                   .foregroundColor(.white)
                   .cornerRadius(15)
                   .transition(.opacity.combined(with: .move(edge: .bottom))) // Animação de entrada/saída
                   .padding(.bottom)
           }
        
    }
    
    private func saveSubmission() {
        let newSubmission = FormSubmission(
            parentFormUUID: form.id,
            fieldValues: self.fieldValues
        )
        
        modelContext.insert(newSubmission)
        
        do {
            try modelContext.save()
            
            dismiss()
            
        } catch {
            print("Cant save: \(error.localizedDescription)")
            
            showTemporaryMessage(text: "Error, try later")
        }
    }
     private func showTemporaryMessage(text: String) {
         self.validationMessage = text
         withAnimation {
             self.showValidationMessage = true
         }
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
             withAnimation {
                 self.showValidationMessage = false
             }
         }
     }
}

private struct SectionView: View {
    let section: Section
    let formFields: [Field]
    @Binding var fieldValues: [String: String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HTMLView(html: section.title)
                .frame(minHeight: 150)

            if section.from < formFields.count && section.to < formFields.count {
                ForEach(formFields[section.from...section.to], id: \.id) { field in
                    FieldView(field: field, value: Binding(
                        get: { self.fieldValues[field.id] ?? "" },
                        set: { self.fieldValues[field.id] = $0 }
                    ))
                }
            }
        }
    }
}


struct FieldView: View {
    let field: Field
    @Binding var value: String
    
    private var labelView: some View {
        HStack(spacing: 2) {
            Text(field.label)
            if field.required == true {
                Text("*")
                    .foregroundColor(.red)
            }
        }
        .font(.headline)
    }
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            switch field.type {
                
            case "description":
                if let htmlLabel = try? AttributedString(markdown: field.label) {
                    Text(htmlLabel)
                }

            case "text", "email", "file":
                labelView
                TextField("", text: $value, prompt: Text(field.label).foregroundColor(.gray.opacity(0.5)))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            
            case "password":
                labelView
                SecureField("", text: $value, prompt: Text(field.label).foregroundColor(.gray.opacity(0.5)))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

            case "date":
                let dateBinding = Binding<Date>(
                    get: { Self.dateFormatter.date(from: self.value) ?? Date() },
                    set: { self.value = Self.dateFormatter.string(from: $0) }
                )
                DatePicker(selection: dateBinding, displayedComponents: .date) {
                    labelView
                }

            case "radio":
                if let options = field.options {
                    labelView
                    VStack(alignment: .leading) {
                        ForEach(options, id: \.value) { option in
                            HStack {
                                Image(systemName: self.value == option.value ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(.accentColor)
                                Text(option.label)
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.value = option.value
                            }
                        }
                    }
                }

            case "number":
                labelView
                TextField("", text: $value, prompt: Text(field.label).foregroundColor(.gray.opacity(0.5)))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
            case "dropdown":
                if let options = field.options {
                    Picker(selection: $value) {
                        Text("Select an option...").tag("")
                        ForEach(options, id: \.value) { option in
                            Text(option.label).tag(option.value)
                        }
                    } label: {
                        labelView
                    }
                    .pickerStyle(.menu)
                }
                
            case "textarea":
               labelView
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $value)
                        .frame(height: 100)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(uiColor: .separator), lineWidth: 1)
                        )

                    if value.isEmpty {
                        Text("Enter details here...")
                            .font(.body)
                            .foregroundColor(.gray.opacity(0.75))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                }
                
            case "checkbox":
                if let options = field.options, !options.isEmpty {
                    labelView
                    VStack(alignment: .leading) {
                        ForEach(options, id: \.value) { option in
                            HStack {
                                Image(systemName: self.value.contains(option.value) ? "checkmark.square.fill" : "square")
                                     .foregroundColor(.accentColor)
                                Text(option.label)
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.toggleCheckbox(value: option.value)
                            }
                        }
                    }
                } else {
                    Toggle(isOn: Binding(
                        get: { self.value == "true" },
                        set: { self.value = $0 ? "true" : "false" }
                    )) {
                        labelView
                    }
                }

            default:
                Text("Unsupported field type: \(field.type)")
            }
        }
        .padding(.bottom)
    }
    
    
    private func toggleCheckbox(value optionValue: String) {
        var selectedValues = self.value.split(separator: ",").map(String.init)
        
        if let index = selectedValues.firstIndex(of: optionValue) {
            selectedValues.remove(at: index)
        } else {
            selectedValues.append(optionValue)
        }
        
        self.value = selectedValues.joined(separator: ",")
    }
}

#Preview {
    let sampleForm = FormModel(
        title: "Preview Form",
        fields: [
            Field(type: "text", label: "Nome", name: "nome", required: true, options: nil, uuid: "uuid1"),
            Field(type: "number", label: "Idade", name: "idade", required: false, options: nil, uuid: "uuid2")
        ],
        sections: nil
    )
    return FormDetailView(form: sampleForm)
}

