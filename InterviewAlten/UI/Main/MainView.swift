//
//  MainView.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 01/03/2023.
//

import SwiftUI

struct MainView<ViewModel: MainViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel = MainViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView() {
            VStack(spacing: 0) {
                List {
                    ForEach(viewModel.datas, id: \.id) { data in
                        NavigationLink(destination: NavigationLazyView(DetailsView(viewModel: DetailsViewModel(data: data)))) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(data.name)
                                    Text(data.getFormattedPrice())
                                }
                                
                                Spacer()
                                
                                URLImage(imageUrl: data.imageUrl)
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing)
                            }
                        }
                    }
                } // LIST
                
                Spacer()
                
                Button("Refresh") {
                    viewModel.fetchItems()
                }
            } // VSTACK
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}
