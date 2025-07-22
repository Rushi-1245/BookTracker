//
//  ContentView.swift
//  BookTracker
//
//  Created by Rushi on 22/07/25.
//

import SwiftUI
import CoreData

enum FilterType: String, CaseIterable, Identifiable {
    case all = "All"
    case read = "Read"
    case unread = "Unread"
    var id: String { self.rawValue }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var filter: FilterType = .all
    @State private var searchText = ""
    @State private var refreshID = UUID()

    private var predicate: NSPredicate? {
        var basePredicate: NSPredicate?

        switch filter {
        case .read:
            basePredicate = NSPredicate(format: "isRead == true")
        case .unread:
            basePredicate = NSPredicate(format: "isRead == false")
        case .all:
            basePredicate = nil
        }

        if searchText.isEmpty {
            return basePredicate
        } else {
            let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            if let base = basePredicate {
                return NSCompoundPredicate(andPredicateWithSubpredicates: [base, searchPredicate])
            } else {
                return searchPredicate
            }
        }
    }

    @FetchRequest private var books: FetchedResults<Book>

    init() {
        _books = FetchRequest<Book>(
            entity: Book.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Book.dateAdded, ascending: false)],
            predicate: nil
        )
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $filter) {
                    ForEach(FilterType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                List {
                    ForEach(filteredBooks(), id: \.self) { book in
                        NavigationLink(destination: EditBookView(book: book)) {
                            BookRowView(book: book)
                        }
                    }
                    .onDelete(perform: deleteBooks)
                }
                .searchable(text: $searchText)
                .navigationTitle("My Books")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink("Add", destination: AddBookView())
                    }
                }
            }
            .id(refreshID)
            .onReceive(NotificationCenter.default.publisher(for: .didUpdateBook)) { _ in
                refreshID = UUID()
            }
        }
    }

    private func filteredBooks() -> [Book] {
        if let predicate {
            return books.filter { predicate.evaluate(with: $0) }
        }
        return Array(books)
    }

    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredBooks()[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

extension Notification.Name {
    static let didUpdateBook = Notification.Name("didUpdateBook")
}
