//
//  ExperiencePresenterNotifier.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 05/06/2025.
//

public protocol ExperiencePresenterNotifierDelegate: AnyObject {
    func navigate(navigationViewModel: NavigationViewModel)

    /// Sends a component's value change to the interactor as deferred work.
    ///
    /// Unlike `navigate(navigationViewModel:)`, this shows no loading overlay and
    /// does not navigate.
    func performDeferredWork(workId: any DeferredWorkID, values: [String])
}

public protocol HasExperiencePresenterNotifier {
    var experiencePresenterNotifier: ExperiencePresenterNotifier { get }
}

public protocol ExperiencePresenterNotifier {
    var delegate: ExperiencePresenterNotifierDelegate? { get set }
}

public final class DefaultExperiencePresenterNotifier: ExperiencePresenterNotifier {
    public weak var delegate: ExperiencePresenterNotifierDelegate?

    public init() {}
}
