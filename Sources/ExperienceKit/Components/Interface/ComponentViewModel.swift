//
//  ComponentViewModel.swift
//
//
//  Created by Sashen Singh on 20/10/2024.
//

import Foundation

public protocol ComponentViewModel {
    associatedtype P: Properties

    var id: UUID { get }

    init(properties: P, id: UUID)
}

public extension ComponentViewModel {
    init(any: Any, id: UUID) {
        self.init(properties: any as! P, id: id)
    }
}
