//
//  SwiftDataStack.swift
//  Segurado
//
//  Created by Guilherme Motti on 09/08/25.
//


import SwiftData

@MainActor
class SwiftDataStack {
    static let shared = SwiftDataStack()

    let container: ModelContainer
    let context: ModelContext

    private init() {
        do {
            container = try ModelContainer(for: 
                FormSubmission.self
            )
            context = container.mainContext
        } catch {
            fatalError("Cant creat SwiftData: \(error)")
        }
    }
}
