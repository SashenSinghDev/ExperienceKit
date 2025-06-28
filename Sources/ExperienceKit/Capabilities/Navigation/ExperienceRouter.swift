//
//  ExperienceRouter.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 28/06/2025.
//

import SwiftUI

public protocol ExperienceRouter: ObservableObject {
    var path: [NavigationViewModel] { get }
    var navigationViewModel: NavigationViewModel? { get }
    var isLoading: Bool { get set }

    func navigate(to navigationViewModel: NavigationViewModel)
}

public protocol HasRouter {
    var router: any ExperienceRouter { get }
}

public class DefaultExperienceRouter: ExperienceRouter {
    @Published public var path: [NavigationViewModel] = []
    @Published public var navigationViewModel: NavigationViewModel? = nil
    @Published public var isLoading: Bool = false

    public init() {}

    public func navigate(to navigationViewModel: NavigationViewModel) {
        switch navigationViewModel.navigationType {
        case .push:
            path.append(navigationViewModel)
        case .modal:
            self.navigationViewModel = navigationViewModel
        }
    }

    // Cache presenters
    private var presenterCache: [UUID: Any] = [:]

    public func storePresenter<T>(_ presenter: T, for id: UUID) {
        presenterCache[id] = presenter
    }

    public func presenter<T>(for id: UUID) -> T? {
        return presenterCache[id] as? T
    }

    public func removePresenter(for id: UUID) {
        if presenterCache[id] != nil {
            print("remove presenter \(id)")
            presenterCache.removeValue(forKey: id)
        }
    }
}
