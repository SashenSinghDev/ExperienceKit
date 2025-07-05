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

public protocol ExperienceRouterDelegate: AnyObject {
    func dismissModal()
}

public protocol HasRouter {
    var router: any ExperienceRouter { get }
}

public class DefaultExperienceRouter: ExperienceRouter {
    @Published public var path: [NavigationViewModel] = []
    @Published public var navigationViewModel: NavigationViewModel? = nil
    @Published public var isLoading: Bool = false

    public weak var delegate: ExperienceRouterDelegate?

    private let expId: String
    private var markedToDismiss: Bool = false

    public init(expId: String) {
        self.expId = expId
        let address = Unmanaged.passUnretained(self).toOpaque()
        print("load Router at address \(address) \(expId)")
    }

    deinit {
        let address = Unmanaged.passUnretained(self).toOpaque()
        print("deint Router at address \(address)")
    }

    public func navigate(to navigationViewModel: NavigationViewModel) {
        switch navigationViewModel.navigationType {
        case .push:
            path.append(navigationViewModel)
        case .modal:
            self.navigationViewModel = navigationViewModel
        case .pop:
            if !path.isEmpty {
                // Pop last pushed view
                _ = path.popLast()
            }
        case .dismiss:
            let address = Unmanaged.passUnretained(self).toOpaque()
            print("dismiss nav func \(address) \(expId)")
            markedToDismiss = true
            presenterCache.removeAll()
            delegate?.dismissModal()
        case .popToRoot:
            path.removeAll()
        }
    }

    // Cache presenters
    private var presenterCache: [UUID: Any] = [:]

    public func storePresenter<T>(_ presenter: T, for id: UUID) {
        guard !markedToDismiss else { return }

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

extension DefaultExperienceRouter: ExperienceRouterDelegate {
    public func dismissModal() {
        let address = Unmanaged.passUnretained(self).toOpaque()
        print("set nav to nil \(address) \(expId)")
        self.navigationViewModel = nil
    }
}
