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

    private let initialRouter: NavigationRouter
    @StateObject private var router: NavigationRouter

    private let fullScreenMainView: AnyView

    init() {
        let dependancyServiceManager = DependancyServiceManager()
        self.dependancyContainer = DependancyContainer(dependencies: dependancyServiceManager)

        let router = NavigationRouter()
        self.initialRouter = router
        self._router = StateObject(wrappedValue: router) // underscore version for init

        self.fullScreenMainView = AnyView(dependancyContainer.makeFullScreenMainView(router: router))
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                fullScreenMainView
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


