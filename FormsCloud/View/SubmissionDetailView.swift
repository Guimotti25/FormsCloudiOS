//
//  SubmissionDetailView.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 10/08/25.
//


import SwiftUI

struct SubmissionDetailView: View {
    let submission: FormSubmission
    let form: FormModel

    var body: some View {
        List {
            ForEach(form.fields) { field in
                if field.type != "description" {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(field.label)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        let answer = submission.fieldValues[field.uuid] ?? "Blank"
                        
                        Text(answer)
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let sampleForm = FormModel(
        title: "Form",
        fields: [
            Field(type: "text", label: "Your name", name: "name", required: true, options: nil, uuid: "uuid1"),
            Field(type: "email", label: "Your email", name: "email", required: true, options: nil, uuid: "uuid2")
        ],
        sections: nil
    )

    let sampleSubmission = FormSubmission(
        parentFormUUID: "form_uuid_preview",
        fieldValues: [
            "uuid1": "Guilherme Motti",
            "uuid2": "exemplo@email.com"
        ]
    )
    
    NavigationStack {
        SubmissionDetailView(submission: sampleSubmission, form: sampleForm)
    }
}
