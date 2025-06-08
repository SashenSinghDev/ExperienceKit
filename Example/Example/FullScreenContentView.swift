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
    @StateObject private var router: NavigationRouter = NavigationRouter()
    @State private var previousPath: [NavigationViewModel] = []

    private let initialViewID = UUID()

    init() {
        let dependancyServiceManager = DependancyServiceManager()
        self.dependancyContainer = DependancyContainer(dependencies: dependancyServiceManager)
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                dependancyContainer.makeFullScreenMainView(router: router,
                                                           existingPresenter: router.presenter(for: initialViewID),
                                                           viewModelID: initialViewID)
                    .navigationDestination(for: NavigationViewModel.self) { viewModel in
                        dependancyContainer.navigationView(for: viewModel.destination, router: router, viewModelID: viewModel.id)
                    }
            }
        }
        .onChange(of: router.path) { newPath in
//            print(newPath)
//            router.removePresenter(for: newPath.id)
            let removed = previousPath.filter { old in !newPath.contains(old) }
            for removedItem in removed {
                router.removePresenter(for: removedItem.id)
            }
            previousPath.append(contentsOf: newPath)
        }
        .fullScreenCover(item: $router.navigationViewModel) { viewModel in
            dependancyContainer.navigationView(for: viewModel.destination, router: router, viewModelID: viewModel.id)
        }
    }
}


