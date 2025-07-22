//
//  AddBookView.swift
//  BookTracker
//
//  Created by Rushi on 22/07/25.
//

import SwiftUI
import PhotosUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var isRead = false
    @State private var notes = ""
    @State private var imageData: Data?

    var body: some View {
        Form {
            Section(header: Text("Book Details")) {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                Toggle("Read", isOn: $isRead)
            }

            Section(header: Text("Notes")) {
                TextEditor(text: $notes)
            }

            Section(header: Text("Cover Image")) {
                ImagePicker(imageData: $imageData)
            }

            Button("Save") {
                let book = Book(context: viewContext)
                book.title = title
                book.author = author
                book.notes = notes
                book.isRead = isRead
                book.dateAdded = Date()
                book.coverImage = imageData
                try? viewContext.save()
                dismiss()
            }
        }
        .navigationTitle("Add Book")
    }
}


#Preview {
    AddBookView()
}
