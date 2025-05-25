//
//  FullScreenContentView.swift
//  Example
//
//  Created by Sashen Singh on 14/12/2024.
//

import SwiftUI
import ExperienceKit

struct FullScreenContentView: View {
    private let dependancyContainer: DependancyContainer
    @StateObject private var router = NavigationRouter()

    init() {
        let dependancyServiceManager = DependancyServiceManager()
        dependancyContainer = DependancyContainer(dependencies: dependancyServiceManager)
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                dependancyContainer.makeFullScreenMainView(router: router)
                    .navigationDestination(for: NavigationViewModel.self) { viewModel in
                        Text(viewModel.destination)
                    }

                if router.isLoading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView("Loading...")
                        .padding()
                        .background(.white)
                        .cornerRadius(12)
                }
            }
            .animation(.easeInOut, value: router.isLoading)

        }
        .fullScreenCover(item: $router.navigationViewModel) { viewModel in
            Text(viewModel.destination)
        }
    }
}


