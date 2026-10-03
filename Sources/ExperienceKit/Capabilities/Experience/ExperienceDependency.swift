//
//  ExperienceDependancy.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/03/2025.
//

public protocol EmptyDependency { }

public class ExperienceDependency: EmptyDependency, HasRouter, HasExperiencePresenterNotifier, HasViewProvider, HasViewModelProvider, HasExperienceAnimationProvider {
    public let router: any ExperienceRouter
    public var experiencePresenterNotifier: ExperiencePresenterNotifier
    public let viewProvider: ViewProvider
    public let viewModelProvider: ViewModelProvider
    public let experienceAnimationProvider: ExperienceAnimationProvider?

    public init(router: any ExperienceRouter,
                experiencePresenterNotifier: ExperiencePresenterNotifier,
                viewProvider: ViewProvider,
                viewModelProvider: ViewModelProvider,
                experienceAnimationProvider: ExperienceAnimationProvider? = nil) {
        self.router = router
        self.experiencePresenterNotifier = experiencePresenterNotifier
        self.viewProvider = viewProvider
        self.viewModelProvider = viewModelProvider
        self.experienceAnimationProvider = experienceAnimationProvider
    }
}
