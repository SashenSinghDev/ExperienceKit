//
//  ExperienceContainerView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/06/2025.
//

import SwiftUI

public protocol ExperienceID: RawRepresentable, Codable, Hashable where RawValue == String {}
public protocol DeferredWorkID: RawRepresentable, Codable, Hashable where RawValue == String {}

public struct ExperienceContainerView: View {

    private let experienceViewID: ExperienceID
    private let presenter: ExperienceContainerPresenter
    @StateObject private var router: DefaultExperienceRouter

    @State private var previousPath: [NavigationViewModel] = []

    private weak var experienceRouterDelegate: ExperienceRouterDelegate?
    private let experienceContainerID = UUID()
    private let navigationBarModel: NavigationBarModel?

    public init(experienceViewID: ExperienceID,
                presenter: ExperienceContainerPresenter,
                experienceRouterDelegate: ExperienceRouterDelegate?,
                navigationBarModel: NavigationBarModel?) {
        self.experienceViewID = experienceViewID
        self.presenter = presenter
        self.experienceRouterDelegate = experienceRouterDelegate
        self.navigationBarModel = navigationBarModel
        _router = StateObject(wrappedValue: DefaultExperienceRouter(expId: experienceViewID))
    }

    public var body: some View {
        NavigationStack(path: $router.path) {
            presenter.experienceView(for: experienceViewID, router: router, navigationBarModel: navigationBarModel, viewModelID: experienceContainerID)
                .navigationDestination(for: NavigationViewModel.self) { viewModel in
                    presenter.experienceView(for: viewModel.destination, router: router, navigationBarModel: viewModel.navigationBarModel, viewModelID: viewModel.id)
                }
        }
        .onChange(of: router.path) { _, newPath in
            DispatchQueue.main.async {
                let removed = previousPath.filter { old in !newPath.contains(old) }
                for removedItem in removed {
                    router.removePresenter(for: removedItem.id)
                }
                previousPath = newPath
            }
        }
        .fullScreenCover(item: $router.navigationViewModel) { viewModel in
            ExperienceContainerView(experienceViewID: viewModel.destination, presenter: presenter, experienceRouterDelegate: router, navigationBarModel: viewModel.navigationBarModel)
        }
        .onAppear {
            if experienceRouterDelegate != nil {
                router.delegate = experienceRouterDelegate
            }
        }
    }
}
