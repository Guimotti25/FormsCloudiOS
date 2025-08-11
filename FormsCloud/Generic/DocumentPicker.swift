//
//  DocumentPicker.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 11/08/25.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedValue: String
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        init(_ parent: DocumentPicker) { self.parent = parent }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            let success = url.startAccessingSecurityScopedResource()
            defer { if success { url.stopAccessingSecurityScopedResource() } }
            parent.selectedValue = url.absoluteString
        }
    }
}
