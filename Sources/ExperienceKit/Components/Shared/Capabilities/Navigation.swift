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
    var path: NavigationPath { get }
    var navigationViewModel: NavigationViewModel? { get }
    var isLoading: Bool { get set }
    var delegate: ExperienceRouterDelegate? { get set }

    func navigate(to navigationViewModel: NavigationViewModel)
}

public class NavigationRouter: ExperienceRouter {
    @Published public var path = NavigationPath()
    @Published public var navigationViewModel: NavigationViewModel? = nil
    @Published public var isLoading: Bool = false

    public weak var delegate: ExperienceRouterDelegate?

    public init() {}

    public func navigate(to navigationViewModel: NavigationViewModel) {
        switch navigationViewModel.navigationType {
        case .push:
            path.append(navigationViewModel)
        case .modal:
            self.navigationViewModel = navigationViewModel
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


