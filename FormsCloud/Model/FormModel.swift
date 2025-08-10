//
//  FormModel.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 09/08/25.
//


struct FormModel: Codable, Identifiable {
    var id: String { title }
    let title: String
    let fields: [Field]
    let sections: [Section]?
}

struct Field: Codable, Identifiable {
    var id: String { uuid }
    let type: String
    let label: String
    let name: String
    let required: Bool?
    let options: [Option]?
    let uuid: String
}

struct Option: Codable {
    let label: String
    let value: String
}

struct Section: Codable, Identifiable {
    var id: String { uuid }
    let title: String
    let from: Int
    let to: Int
    let index: Int
    let uuid: String
}


