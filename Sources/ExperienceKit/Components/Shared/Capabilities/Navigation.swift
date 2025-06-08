//
//  Navigation.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 23/02/2025.
//

import Foundation
import SwiftUI

public struct NavigationViewModel: Identifiable, Hashable {
    public let id = UUID()
    public let navigationType: NavigationType
    public let deferredLoadingWorkId: String?
    public var destination: String {
        switch navigationType {
            case .push(let value):
            return value
        case .modal(let value):
            return value
        }
    }
}

public struct NavigationProperties: Codable {
    let navigationType: NavigationType
    let deferredLoadingWorkId: String?
}

public protocol ExperienceRouterDelegate: AnyObject {
    func navigate(to navigationViewModel: NavigationViewModel)
}

public protocol ExperienceRouter: ObservableObject {
    var path: [NavigationViewModel] { get }
    var navigationViewModel: NavigationViewModel? { get }
    var isLoading: Bool { get set }

    func navigate(to navigationViewModel: NavigationViewModel)
}

public protocol NavigationViewProvider {
    func navigationView(for id: String) -> ExperienceView<ExperiencePresenter>
}

public class NavigationRouter: ExperienceRouter {
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

public enum NavigationType: Equatable, Identifiable, Codable, Hashable {
    case push(String)
    case modal(String)

    public var id: String {
        switch self {
        case .push(let value), .modal(let value):
            return value
        }
    }
}


