//
//  FormSubmission.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 10/08/25.
//


import Foundation
import SwiftData

@Model
final class FormSubmission {
    @Attribute(.unique) var id: UUID
    var parentFormUUID: String // Para saber qual formulário foi preenchido (ex: o UUID de "all-fields")
    var fieldValues: [String: String] // Dicionário para guardar as respostas [field_uuid: value]
    var createdAt: Date
    
    init(parentFormUUID: String, fieldValues: [String: String]) {
        self.id = UUID()
        self.parentFormUUID = parentFormUUID
        self.fieldValues = fieldValues
        self.createdAt = .now
    }
}