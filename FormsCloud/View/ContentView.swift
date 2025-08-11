//
//  ContentView.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 09/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var forms: [(fileName: String, model: FormModel)] = []
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            List(forms, id: \.fileName) { item in
                         
                 NavigationLink(destination: EntryListView(form: item.model, modelContext: modelContext)) {
                     Text(item.model.title)
                         .font(.headline)
                 }
             }
            .navigationTitle("Forms")
            .onAppear {
                if forms.isEmpty {
                    if let f1 = loadForm(named: "all-fields", inDirectory: "") {
                        forms.append(("all-fields", f1))
                    }
                    if let f2 = loadForm(named: "200-form", inDirectory: "") {
                        forms.append(("200-form", f2))
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
