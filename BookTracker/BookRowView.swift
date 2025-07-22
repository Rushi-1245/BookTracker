//
//  BookRowView.swift
//  BookTracker
//
//  Created by Rushi on 22/07/25.
//

import SwiftUI

struct BookRowView: View {
    var book: Book

    var body: some View {
        HStack {
            if let data = book.coverImage, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 50, height: 70)
                    .cornerRadius(5)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 70)
                    .cornerRadius(5)
                    .overlay(Text("No Image").font(.caption))
            }

            VStack(alignment: .leading) {
                Text(book.title ?? "Untitled").font(.headline)
                Text(book.author ?? "Unknown").font(.subheadline)
            }

            Spacer()

            if book.isRead {
                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
            }
        }
    }
}

//#Preview {
//    BookRowView()
//}
