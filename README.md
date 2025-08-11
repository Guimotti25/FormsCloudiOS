
FormsCloud for iOS
Overview
FormsCloud for iOS is a native and robust application that dynamically renders complex forms from a JSON definition.
This project demonstrates how to build rich, data-driven user interfaces using Apple’s latest technologies such as SwiftUI and SwiftData, following the MVVM architecture.
Key Features
📱 100% Native Interface with SwiftUI
The entire user interface is built with SwiftUI, ensuring a smooth, reactive, and modern experience.
📄 Dynamic JSON Rendering
The app reads a JSON structure to build forms at runtime, allowing the form layout to be updated without the need for an app release.

🎨 Support for Multiple Field Types
Renders a wide range of native UI components, including:

Text fields (TextField), email, and password fields (SecureField)
Calendar date pickers (DatePicker)
Radio buttons for single selection
Checkboxes for multiple selection
Dropdown menus (Picker)
Multi-line text areas (TextEditor)
🗂️ Sections with Rich HTML Content
Groups fields into sections with titles that support HTML content, including rendering images from the web via a WKWebView wrapper.
💾 Local Persistence with SwiftData
Form responses are securely stored on the device using Apple’s SwiftData framework, ensuring high performance and seamless SwiftUI integration.

📂 Attachment Viewing
The details screen can display files attached by the user, distinguishing between:

Images, loaded asynchronously with AsyncImage
PDF documents, rendered using a PDFKit wrapper
✅ Real-Time Validation
The save button is dynamically enabled or disabled based on whether all required fields (required: true) have been filled in.
🏛️ MVVM Architecture
The code has been refactored to follow the Model-View-ViewModel (MVVM) pattern. Business logic and state management reside in the ViewModel (ObservableObject), while the View (SwiftUI) is responsible only for presentation — resulting in cleaner, decoupled, and easier-to-test code.

🗑️ Data Management
Users can list all submissions for a form, view details for each one, and delete them via a long-press gesture with a confirmation alert.

Tech Stack
Language: Swift 5
UI Framework: SwiftUI
Database: SwiftData
Architecture: MVVM
HTML Rendering: WebKit (WKWebView via UIViewRepresentable)
PDF Viewing: PDFKit (via UIViewRepresentable)
File Selection: UIDocumentPickerViewController (via UIViewControllerRepresentable)


Running the project in Xcode - Version 16.2 (16C5032a)
