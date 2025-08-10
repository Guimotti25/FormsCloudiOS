//
//  SubmissionCardView.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 10/08/25.
//


import SwiftUI

struct SubmissionCardView: View {
    // This view only needs the submission object to display its data.
    let submission: FormSubmission

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: - Submission Date
            Text("Submitted on: \(submission.createdAt, format: .dateTime.day().month().year())")
                .font(.caption)
                .foregroundColor(.secondary)

            // MARK: - Primary Info (Submitter's Name)
            // It fetches the values using the specific UUIDs from your JSON form.
            let firstName = submission.fieldValues["1e8562c5-1541-4c6f-aabb-000000000001"] ?? "N/A"
            let lastName = submission.fieldValues["1e8562c5-1541-4c6f-aabb-000000000002"] ?? ""
            
            Text("\(firstName) \(lastName)")
                .font(.headline)

            // MARK: - Secondary Info (Submitter's Email)
            let email = submission.fieldValues["1e8562c5-1541-4c6f-aabb-000000000003"] ?? "No email provided"
            
            Text(email)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        // Add some padding to make it look good inside the list row.
        .padding(.vertical, 8)
    }
}
