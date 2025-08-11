//
//  SubmissionCardView.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 10/08/25.
//


import SwiftUI
import SwiftData

struct SubmissionCardView: View {
    let submission: FormSubmission

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Submitted on: \(submission.createdAt, format: .dateTime.day().month().year())")
                .font(.caption)
                .foregroundColor(.secondary)

            // ATUALIZADO: Buscando os valores pelo 'name' do campo
            let firstName = submission.fieldValues["first_name"] ?? "N/A"
            let lastName = submission.fieldValues["last_name"] ?? ""
            
            Text("\(firstName) \(lastName)")
                .font(.headline)

            let email = submission.fieldValues["email"] ?? "No email provided"
            
            Text(email)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
