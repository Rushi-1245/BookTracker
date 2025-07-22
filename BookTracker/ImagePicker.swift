//
//  ImagePicker.swift
//  BookTracker
//
//  Created by Rushi on 22/07/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var imageData: Data?

    var body: some View {
        PhotosPicker(selection: Binding(get: {
            nil
        }, set: { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }), matching: .images, photoLibrary: .shared()) {
            Text("Choose Image")
        }

        if let imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
        }
    }
}
