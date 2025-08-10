//
//  FieldCardView.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 09/08/25.
//


import SwiftUI

struct FieldCardView: View {
    var field: Field

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(field.label)
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                Text("Type:")
                    .fontWeight(.semibold)
                Text(field.type)
            }

            HStack {
                Text("Name:")
                    .fontWeight(.semibold)
                Text(field.name)
            }

            HStack {
                Text("Required:")
                    .fontWeight(.semibold)
                Text((field.required ?? false) ? "Yes" : "No")
                    .foregroundColor((field.required ?? false) ? .red : .green)
            }

            Text("UUID:")
                .fontWeight(.semibold)
            Text(field.uuid)
                .font(.footnote)
                .foregroundColor(.gray)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .padding()
        .background(Color.white) // Mantém o fundo do cartão branco
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .center) // Centraliza o cartão
    }
}


struct FieldCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFieldWithOptions = Field(
            type: "select",
            label: "Select Field",
            name: "select_field",
            required: false,
            options: [
                Option(label: "Option 1", value: "1"),
                Option(label: "Option 2", value: "2")
            ],
            uuid: "abc123-uuid-456"
        )

        let sampleFieldNoOptions = Field(
            type: "text",
            label: "Text Field 1",
            name: "text_field_1",
            required: true,
            options: nil,
            uuid: "6e9ade09-79cd-4b45-8132-cd1512db568c"
        )

        Group {
            FieldCardView(field: sampleFieldWithOptions)
            FieldCardView(field: sampleFieldNoOptions)
        }
        .previewLayout(.sizeThatFits)
    }
}
