//
//  Edit.swift
//  BookTracker
//
//  Created by Rushi on 22/07/25.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var book: Book

    @State private var title: String = ""
    @State private var author: String = ""
    @State private var notes: String = ""
    @State private var isRead: Bool = false
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

            Button("Update") {
                book.title = title
                book.author = author
                book.notes = notes
                book.isRead = isRead
                book.coverImage = imageData
                try? viewContext.save()
                NotificationCenter.default.post(name: .didUpdateBook, object: nil)
                dismiss()
            }
        }
        .onAppear {
            title = book.title ?? ""
            author = book.author ?? ""
            notes = book.notes ?? ""
            isRead = book.isRead
            imageData = book.coverImage
        }
        .navigationTitle("Edit Book")
    }
}


//#Preview {
//    EditBookView()
//}
