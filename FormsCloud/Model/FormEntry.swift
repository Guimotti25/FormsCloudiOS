//
//  FormEntry.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 09/08/25.
//

import Foundation

struct FormEntry: Identifiable, Decodable, Encodable {
    var id = UUID()
    var date: Date
    var summary: String
    
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
