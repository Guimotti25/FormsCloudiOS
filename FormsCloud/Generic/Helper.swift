//
//  Helper.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 09/08/25.
//

import Foundation

func loadJSONFile(named fileName: String, inDirectory directory: String? = "Json") -> String? {
    if let path = Bundle.main.path(forResource: fileName, ofType: "json", inDirectory: directory) {
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            print("Error \(fileName): \(error)")
            return nil
        }
    } else {
        print("File not founded in bundle: \(fileName).json (dir: \(directory ?? "nil"))")
    }
    return nil
}

func loadForm(named fileName: String, inDirectory directory: String? = "Json") -> FormModel? {
    guard let jsonString = loadJSONFile(named: fileName, inDirectory: directory) else { return nil }
    let data = Data(jsonString.utf8)
    do {
        return try JSONDecoder().decode(FormModel.self, from: data)
    } catch {
        print("Error \(fileName): \(error)")
        return nil
    }
}
