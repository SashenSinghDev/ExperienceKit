//
//  ScrollableContentView.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import SwiftUI
import ExperienceKit

struct ScrollableContentView: View {
    private let dependancyContainer: DependancyContainer
    @StateObject private var router = NavigationRouter()

    init() {
        let dependancyServiceManager = DependancyServiceManager()
        dependancyContainer = DependancyContainer(dependencies: dependancyServiceManager)
    }

    var body: some View {
        dependancyContainer.makeScrollableMainView(router: router)
            .navigationDestination(for: ExampleViewModel.self) { viewModel in
                Text("\(viewModel.publishedAmount)")
            }
            .navigationTitle("ExprienceKit")
    }
}

#Preview {
    ScrollableContentView()
}
