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

public class ExperienceDependency: EmptyDependency, HasRouter {
    public let router: any ExperienceRouter

    public init(router: any ExperienceRouter) {
        self.router = router
    }
}
