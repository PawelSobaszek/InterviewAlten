//
//  NavigationLazyView.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 06/03/2023.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}
