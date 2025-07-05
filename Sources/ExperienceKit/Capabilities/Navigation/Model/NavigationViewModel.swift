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
        case .dismiss, .pop, .popToRoot:
            fatalError("dismiss navigation type not supported with destination")
        }
    }

    public init(navigationType: NavigationType, deferredLoadingWorkId: String?) {
        self.navigationType = navigationType
        self.deferredLoadingWorkId = deferredLoadingWorkId
    }
    
}

public enum NavigationType: Equatable, Identifiable, Codable, Hashable {
    case push(String)
    case modal(String)
    case dismiss
    case pop
    case popToRoot

    // TODO: add dismiss case here

    public var id: String {
        switch self {
        case .push(let value), .modal(let value):
            return value
        case .dismiss, .pop, .popToRoot:
            fatalError("dismiss navigation type not supported with id")
        }
    }
}

