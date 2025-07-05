//
//  ExperienceContainerView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/06/2025.
//

import SwiftUI

public struct ExperienceContainerView: View {

    private let experienceViewID: String
    private let presenter: ExperienceContainerPresenter
    @StateObject private var router: DefaultExperienceRouter

    @State private var previousPath: [NavigationViewModel] = []

    private weak var experienceRouterDelegate: ExperienceRouterDelegate?
    private let experienceContainerID = UUID()

    public init(experienceViewID: String,
                presenter: ExperienceContainerPresenter,
                experienceRouterDelegate: ExperienceRouterDelegate?) {
        self.experienceViewID = experienceViewID
        self.presenter = presenter
        self.experienceRouterDelegate = experienceRouterDelegate
        _router = StateObject(wrappedValue: DefaultExperienceRouter(expId: experienceViewID))
    }

    public var body: some View {
        NavigationStack(path: $router.path) {
            presenter.experienceView(for: experienceViewID, router: router, viewModelID: experienceContainerID, experienceID: experienceViewID)
                .navigationDestination(for: NavigationViewModel.self) { viewModel in
                    presenter.experienceView(for: viewModel.destination, router: router, viewModelID: viewModel.id, experienceID: experienceViewID)
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
            ExperienceContainerView(experienceViewID: viewModel.destination, presenter: presenter, experienceRouterDelegate: router)
        }
        .onAppear {
            if experienceRouterDelegate != nil {
                router.delegate = experienceRouterDelegate
            }
        }
    }
}
