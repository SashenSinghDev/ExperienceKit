//
//  NavigationViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 28/06/2025.
//

import Foundation

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

