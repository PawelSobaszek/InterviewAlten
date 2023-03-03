//
//  DetailsView.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 02/03/2023.
//

import SwiftUI

struct DetailsView<ViewModel: DetailsViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                Text(viewModel.data.name)
                Text(viewModel.data.getFormattedPrice())
                Text(viewModel.data.description)
                HStack {
                    Spacer()
                    URLImage(imageUrl: viewModel.data.imageUrl)
                        .frame(width: 200, height: 200)
                    Spacer()
                }
            }
        } // VSTACK
        .navigationTitle("Details")
    }
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView(name: "Product 1")
//    }
//}
