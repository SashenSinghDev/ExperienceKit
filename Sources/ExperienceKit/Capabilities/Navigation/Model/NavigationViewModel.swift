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
    public let deferredLoadingWorkId: DeferredWorkID?
    public let experienceViewModel: ExperienceViewModel?
    public var destination: ExperienceID {
        switch navigationType {
            case .push(let value):
            return value
        case .modal(let value):
            return value
        case .dismiss, .pop, .popToRoot:
            fatalError("dismiss navigation type not supported with destination")
        }
    }

    public init(navigationType: NavigationType, deferredLoadingWorkId: DeferredWorkID?,
                experienceViewModel: ExperienceViewModel?) {
        self.navigationType = navigationType
        self.deferredLoadingWorkId = deferredLoadingWorkId
        self.experienceViewModel = experienceViewModel
    }

    public static func == (lhs: NavigationViewModel, rhs: NavigationViewModel) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct AnyExperienceID: ExperienceID {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ experienceID: ExperienceID) {
        self.rawValue = experienceID.rawValue
    }
}

public enum NavigationType: Identifiable, Codable, Hashable {
    case push(ExperienceID)
    case modal(ExperienceID)
    case dismiss
    case pop
    case popToRoot

    public var id: String {
        switch self {
        case .push(let value):
            return "push:\(value.rawValue)"
        case .modal(let value):
            return "modal:\(value.rawValue)"
        case .dismiss:
            return "dismiss"
        case .pop:
            return "pop"
        case .popToRoot:
            return "popToRoot"
        }
    }

    public static func == (lhs: NavigationType, rhs: NavigationType) -> Bool {
        switch (lhs, rhs) {
        case (.push(let lhsValue), .push(let rhsValue)),
            (.modal(let lhsValue), .modal(let rhsValue)):
            return lhsValue.rawValue == rhsValue.rawValue
        case (.dismiss, .dismiss),
            (.pop, .pop),
            (.popToRoot, .popToRoot):
            return true
        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .push(let value):
            hasher.combine("push")
            hasher.combine(value.rawValue)
        case .modal(let value):
            hasher.combine("modal")
            hasher.combine(value.rawValue)
        case .dismiss:
            hasher.combine("dismiss")
        case .pop:
            hasher.combine("pop")
        case .popToRoot:
            hasher.combine("popToRoot")
        }
    }
}

extension NavigationType {
    private enum CodingKeys: String, CodingKey {
        case type
        case destination
    }

    private enum NavigationTypeValue: String, Codable {
        case push
        case modal
        case dismiss
        case pop
        case popToRoot
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(NavigationTypeValue.self, forKey: .type)

        switch type {
        case .push:
            let destination = try container.decode(String.self, forKey: .destination)
            self = .push(AnyExperienceID(rawValue: destination))
        case .modal:
            let destination = try container.decode(String.self, forKey: .destination)
            self = .modal(AnyExperienceID(rawValue: destination))
        case .dismiss:
            self = .dismiss
        case .pop:
            self = .pop
        case .popToRoot:
            self = .popToRoot
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .push(let value):
            try container.encode(NavigationTypeValue.push, forKey: .type)
            try container.encode(value.rawValue, forKey: .destination)
        case .modal(let value):
            try container.encode(NavigationTypeValue.modal, forKey: .type)
            try container.encode(value.rawValue, forKey: .destination)
        case .dismiss:
            try container.encode(NavigationTypeValue.dismiss, forKey: .type)
        case .pop:
            try container.encode(NavigationTypeValue.pop, forKey: .type)
        case .popToRoot:
            try container.encode(NavigationTypeValue.popToRoot, forKey: .type)
        }
    }
}
