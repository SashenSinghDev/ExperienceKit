//
//  ExperienceDependancy.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/03/2025.
//

import Combine

public protocol EmptyDependency { }

public class ExperienceDependency: EmptyDependency, HasRouter, HasExperiencePresenterNotifier, HasViewProvider, HasViewModelProvider, HasExperienceSelectionStateStore, HasExperienceSelectionChanges {
    public let router: any ExperienceRouter
    public var experiencePresenterNotifier: ExperiencePresenterNotifier
    public let viewProvider: ViewProvider
    public let viewModelProvider: ViewModelProvider
    public let experienceSelectionStateStore: ExperienceSelectionStateStore?
    public let experienceSelectionChanges: AnyPublisher<String, Never>

    public init(router: any ExperienceRouter,
                experiencePresenterNotifier: ExperiencePresenterNotifier,
                viewProvider: ViewProvider,
                viewModelProvider: ViewModelProvider,
                experienceSelectionStateStore: ExperienceSelectionStateStore? = nil) {
        self.router = router
        self.experiencePresenterNotifier = experiencePresenterNotifier
        self.viewProvider = viewProvider
        self.viewModelProvider = viewModelProvider
        // Components write through the observed wrapper so others on the screen can react.
        let observedStore = experienceSelectionStateStore.map(ObservedExperienceSelectionStateStore.init(base:))
        self.experienceSelectionStateStore = observedStore
        self.experienceSelectionChanges = observedStore?.changes ?? Empty().eraseToAnyPublisher()
    }
}
