//
//  ExperienceDependancy.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/03/2025.
//

public protocol EmptyDependency { }

public protocol HasRouter {
    var router: any ExperienceRouter { get }
}

public protocol HasExperiencePresenterNotifier {
    var experiencePresenterNotifier: ExperiencePresenterNotifier { get }
}

public protocol HasNavigationViewProvider {
    var navigationViewProvider: any NavigationViewProvider { get }
}

public class ExperienceDependency: EmptyDependency, HasRouter, HasExperiencePresenterNotifier {
    public let router: any ExperienceRouter
    public var experiencePresenterNotifier: ExperiencePresenterNotifier
//    public let navigationViewProvider: any NavigationViewProvider

    public init(router: any ExperienceRouter, experiencePresenterNotifier: ExperiencePresenterNotifier) {
        self.router = router
        self.experiencePresenterNotifier = experiencePresenterNotifier
//        self.navigationViewProvider = navigationViewProvider
    }
}
