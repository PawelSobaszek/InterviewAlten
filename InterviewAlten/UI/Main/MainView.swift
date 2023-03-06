//
//  MainView.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 01/03/2023.
//

import SwiftUI

enum MainViewState: Equatable {
    case START
    case LOADING
    case SUCCESS(datas: [DataModel])
    case FAILURE(error: String)
}

struct MainView<ViewModel: MainViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel = MainViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        switch viewModel.state {
        case .START, .LOADING:
            VStack() {
                ProgressView()
            }
        case .SUCCESS(let datas):
            NavigationView() {
                VStack(spacing: 0) {
                    List {
                        ForEach(datas, id: \.id) { data in
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
        case .FAILURE(let error):
            VStack() {
                Text(error)
                
                Button("Refresh") {
                    viewModel.fetchItems()
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
