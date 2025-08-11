//
//  SubmissionDetailView.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 10/08/25.
//

import SwiftUI
import SwiftData
import PDFKit
import UniformTypeIdentifiers

struct SubmissionDetailView: View {
    let submission: FormSubmission
    let form: FormModel

    private var displayableFields: [Field] {
        form.fields.filter { field in
            field.type != "description" && field.name != "terms"
        }
    }

    var body: some View {
        List {
            ForEach(displayableFields) { field in
                SubmissionDetailRow(field: field, submission: submission)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - View Auxiliar para cada Linha da Lista
private struct SubmissionDetailRow: View {
    let field: Field
    let submission: FormSubmission

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(field.label)
                .font(.headline)
                .foregroundColor(.secondary)

            answerView
        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var answerView: some View {
        let savedValue = submission.fieldValues[field.name] ?? "Blank"

        switch field.type {
        case "password":
            Text("••••••••")
                .font(.body)
                .fontWeight(.medium)
            
        case "radio", "dropdown":
            let displayText = field.options?.first { $0.value == savedValue }?.label ?? savedValue
            Text(displayText)
                .font(.body)
                .fontWeight(.medium)
            
        case "checkbox":
            let values = savedValue.split(separator: ",").map(String.init)
            let labels = values.compactMap { value in
                field.options?.first { $0.value == value }?.label
            }
            Text(labels.joined(separator: ", "))
                .font(.body)
                .fontWeight(.medium)
            
        case "file":
            if let url = URL(string: savedValue) {
                let pathExtension = url.pathExtension.lowercased()
                
                if ["png", "jpg", "jpeg", "heic", "gif"].contains(pathExtension) {
                    AsyncImage(url: url) { image in
                        image.resizable().aspectRatio(contentMode: .fit).cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxHeight: 250)
                }
                else if pathExtension == "pdf" {
                    PDFKitView(url: url)
                        .frame(height: 350)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))

                }
                else {
                    HStack {
                        Image(systemName: "doc.text.fill")
                        Text(url.lastPathComponent)
                    }
                    .foregroundColor(.secondary)
                }
            } else {
                Text("Invalid file path").font(.body).fontWeight(.medium)
            }
            
        default:
            Text(savedValue)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

// MARK: - View para Renderizar PDFs
private struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        if let document = PDFDocument(url: self.url) {
            pdfView.document = document
        }
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}


// MARK: - Preview
#Preview {
    // Para o preview do PDF funcionar, adicione um arquivo PDF de exemplo ao seu projeto
    // e chame-o de "sample.pdf"
    let samplePDFURL = Bundle.main.url(forResource: "sample", withExtension: "pdf")?.absoluteString ?? ""
    
    let sampleForm = FormModel(
        title: "Preview Form",
        fields: [
            Field(type: "text", label: "Your name", name: "name", required: true, options: nil, uuid: "uuid1"),
            Field(type: "dropdown", label: "Country", name: "country", required: true, options: [Option(label: "Brazil", value: "br")], uuid: "uuid3"),
            Field(type: "file", label: "Attachment (PDF)", name: "attachment_pdf", required: false, options: nil, uuid: "uuid4"),
            Field(type: "file", label: "Attachment (Image)", name: "attachment_img", required: false, options: nil, uuid: "uuid5"),
            Field(type: "checkbox", label: "I agree to the terms and conditions", name: "terms", required: true, options: nil, uuid: "uuid6")
        ],
        sections: nil
    )

    let sampleSubmission = FormSubmission(
        parentFormUUID: "form_uuid_preview",
        fieldValues: [
            "name": "Guilherme Motti",
            "country": "br", // Salva o valor 'br'
            "attachment_pdf": samplePDFURL,
            "attachment_img": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzRLynGuRfxgxbM1SdTqhYWm39PHEpWu96Xg&s"
        ]
    )
    
    return NavigationStack {
        SubmissionDetailView(submission: sampleSubmission, form: sampleForm)
    }
}
