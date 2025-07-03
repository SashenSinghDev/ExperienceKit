//
//  ExperiencePresenterNotifier.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 05/06/2025.
//

public protocol ExperiencePresenterNotifierDelegate: AnyObject {
//    func performDeferredWork(workId: String, completion: @escaping () -> Void)
    func navigate(navigationViewModel: NavigationViewModel)
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
