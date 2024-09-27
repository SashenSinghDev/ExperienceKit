//
//  Experience.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation

public enum Experience {
    public enum Action {
        case load
    }

    public enum Update {
        case setAnyViewModel(ViewModels)
    }

    public struct ViewModels {
        public let components: [AnyComponentViewModel]

        public init(components: [AnyComponentViewModel]) {
            self.components = components
        }
    }
}

public extension Experience.ViewModels {
    public static let defaultState = Experience.ViewModels(components: [])
}
