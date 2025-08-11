//
//  NewFormsViewModel.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 10/08/25.
//

import SwiftUI
import SwiftData
import WebKit
import UniformTypeIdentifiers

struct NewFormsView: View {
    @StateObject private var viewModel: NewFormsViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let form: FormModel

    init(form: FormModel, modelContext: ModelContext) {
        self.form = form
        _viewModel = StateObject(wrappedValue: NewFormsViewModel(form: form, modelContext: modelContext))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let sections = form.sections, !sections.isEmpty {
                        ForEach(sections.sorted(by: { $0.index < $1.index })) { section in
                            SectionView(section: section, formFields: form.fields, viewModel: viewModel)
                        }
                    } else {
                        ForEach(form.fields) { field in
                            FieldView(field: field, value: viewModel.binding(for: field.name))
                        }
                    }

                    Button("Save") {
                        if viewModel.isFormInvalid {
                            viewModel.showTemporaryMessage(text: "Fill in all required fields (*)")
                        } else {
                            viewModel.saveSubmission {
                                dismiss()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isFormInvalid ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .animation(.easeInOut, value: viewModel.isFormInvalid)
                    .cornerRadius(8)
                }
                .padding()
                .padding(.bottom, 60)
            }
            .navigationTitle(form.title)
            .navigationBarTitleDisplayMode(.inline)

            if viewModel.showValidationMessage {
                Text(viewModel.validationMessage)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .padding(.bottom)
            }
        }
    }
}

// MARK: - SectionView
private struct SectionView: View {
    let section: Section
    let formFields: [Field]
    @ObservedObject var viewModel: NewFormsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HTMLView(html: section.title)
                .frame(minHeight: 150)

            if section.from < formFields.count && section.to < formFields.count {
                ForEach(formFields[section.from...section.to]) { field in
                    FieldView(field: field, value: viewModel.binding(for: field.name))
                }
            }
        }
    }
}

// MARK: - FieldView
private struct FieldView: View {
    let field: Field
    @Binding var value: String
    @State private var showFilePicker = false
    
    private var labelView: some View {
        HStack(spacing: 2) {
            Text(field.label)
            if field.required == true {
                Text("*").foregroundColor(.red)
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
                if let htmlLabel = try? AttributedString(markdown: field.label) { Text(htmlLabel) }
            case "text", "email":
                labelView
                TextField(field.label, text: $value).textFieldStyle(.roundedBorder)
            case "password":
                labelView
                SecureField(field.label, text: $value).textFieldStyle(.roundedBorder)
            case "number":
                labelView
                TextField(field.label, text: $value).textFieldStyle(.roundedBorder).keyboardType(.numberPad)
            case "date":
                let dateBinding = Binding<Date>(
                    get: { Self.dateFormatter.date(from: self.value) ?? Date() },
                    set: { self.value = Self.dateFormatter.string(from: $0) }
                )
                DatePicker(selection: dateBinding, displayedComponents: .date) { labelView }
            case "radio":
                if let options = field.options {
                    labelView
                    ForEach(options, id: \.value) { option in
                        HStack {
                            Image(systemName: self.value == option.value ? "largecircle.fill.circle" : "circle").foregroundColor(.accentColor)
                            Text(option.label)
                        }.padding(.vertical, 2).contentShape(Rectangle()).onTapGesture { self.value = option.value }
                    }
                }
            case "checkbox":
                if let options = field.options, !options.isEmpty {
                    labelView
                    ForEach(options, id: \.value) { option in
                        HStack {
                            Image(systemName: self.value.contains(option.value) ? "checkmark.square.fill" : "square").foregroundColor(.accentColor)
                            Text(option.label)
                        }.padding(.vertical, 2).contentShape(Rectangle()).onTapGesture { self.toggleCheckbox(value: option.value) }
                    }
                } else {
                    Toggle(isOn: Binding(
                        get: { self.value == "true" },
                        set: { self.value = $0 ? "true" : "false" }
                    )) { labelView }
                }
            case "dropdown":
                if let options = field.options {
                    Picker(selection: $value) {
                        Text("Select a \(field.label)...").tag("")
                        ForEach(options, id: \.value) { option in Text(option.label).tag(option.value) }
                    } label: { labelView }.pickerStyle(.menu)
                }
            case "textarea":
                labelView
                TextEditor(text: $value).frame(height: 100).cornerRadius(6).overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.5)))
            case "file":
                labelView
                HStack {
                    Text(value.isEmpty ? "No file selected" : URL(string: value)?.lastPathComponent ?? "File")
                        .font(.body).foregroundColor(value.isEmpty ? .secondary : .primary)
                    Spacer()
                    Button("Select File") { showFilePicker = true }
                }.padding(.vertical, 8)
            default:
                Text("Unsupported field type: \(field.type)")
            }
        }
        .padding(.bottom)
        .sheet(isPresented: $showFilePicker) {
            DocumentPicker(selectedValue: $value)
        }
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


