//
//  ProfilePicView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 10.03.2024.
//

import SwiftUI

import SwiftUI

struct ProfilePicView: View {
    var imageURL: String?
    
    var body: some View {
        if let imageURL = imageURL {
            AsyncImage(url: URL(string: imageURL)) { image in
                image.resizable()
            } placeholder: {
                // Placeholder view while the image is loading
                ProgressView()
            }
            .frame(width: 110, height: 110)
            .clipShape(Circle())
        } else {
            // Placeholder view for when there's no image URL
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    ProfilePicView()
}
