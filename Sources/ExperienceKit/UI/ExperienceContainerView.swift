//
//  ExperienceContainerView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/06/2025.
//

import SwiftUI

public struct ExperienceContainerView: View {

    private let experienceViewID: String
    private let dependancyContainer: ExperienceDependancyContainer
    @StateObject private var router: NavigationRouter = NavigationRouter()
    @State private var previousPath: [NavigationViewModel] = []

    private let experienceContainerID = UUID()

    public init(experienceViewID: String,
         dependancyContainer: ExperienceDependancyContainer) {
        self.dependancyContainer = dependancyContainer
        self.experienceViewID = experienceViewID
    }

    public var body: some View {
        NavigationStack(path: $router.path) {
            dependancyContainer.experienceView(for: experienceViewID, router: router, viewModelID: experienceContainerID)
                .navigationDestination(for: NavigationViewModel.self) { viewModel in
                    dependancyContainer.experienceView(for: viewModel.destination, router: router, viewModelID: viewModel.id)
                }
        }
        .onChange(of: router.path) { _, newPath in
            let removed = previousPath.filter { old in !newPath.contains(old) }
            for removedItem in removed {
                router.removePresenter(for: removedItem.id)
            }
            previousPath.append(contentsOf: newPath)
        }
        .fullScreenCover(item: $router.navigationViewModel) { viewModel in
            dependancyContainer.experienceView(for: viewModel.destination, router: router, viewModelID: viewModel.id)
        }
    }
}
