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
        case setAnyViewModel(AnyViewModel)
    }

    public struct AnyViewModel {
        let components: [AnyComponentViewModel]
    }
}

extension Experience.AnyViewModel {
    static let defaultState = Experience.AnyViewModel(components: [])
}
