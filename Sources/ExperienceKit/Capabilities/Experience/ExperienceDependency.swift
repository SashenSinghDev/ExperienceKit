//
//  ExperienceDependancy.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/03/2025.
//

public protocol EmptyDependency { }

public class ExperienceDependency: EmptyDependency, HasRouter, HasExperiencePresenterNotifier {
    public let router: any ExperienceRouter
    public var experiencePresenterNotifier: ExperiencePresenterNotifier

    public init(router: any ExperienceRouter, experiencePresenterNotifier: ExperiencePresenterNotifier) {
        self.router = router
        self.experiencePresenterNotifier = experiencePresenterNotifier
    }
}
