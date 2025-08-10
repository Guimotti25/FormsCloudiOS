//
//  FormsCloudApp.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 09/08/25.
//

import SwiftUI
import SwiftData

@main
struct FormsCloudApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.modelContext, SwiftDataStack.shared.context)
        }
    }
}
