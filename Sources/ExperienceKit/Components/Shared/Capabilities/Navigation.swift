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
}

public protocol ExperienceRouter: ObservableObject {
    var path: NavigationPath { get set }
    var navigationViewModel: NavigationViewModel? { get set }
}

public class NavigationRouter: ExperienceRouter {
    @Published public var path = NavigationPath()
    @Published public var navigationViewModel: NavigationViewModel? = nil

    public init() {}
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


