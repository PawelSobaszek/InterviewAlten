//
//  URLImage.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 02/03/2023.
//

import SwiftUI

struct URLImage: View {
    let imageUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if phase.error != nil {
                Text("404! \n No image available 😢")
                    .bold()
                    .font(.title)
                    .multilineTextAlignment(.center)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        URLImage(imageUrl: "https://www.badurl.com")
    }
}
