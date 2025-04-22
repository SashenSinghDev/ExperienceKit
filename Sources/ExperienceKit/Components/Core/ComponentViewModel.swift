//
//  ComponentViewModel.swift
//
//
//  Created by Sashen Singh on 20/10/2024.
//

import Foundation

public protocol ComponentViewModel {
    associatedtype P: Properties
    associatedtype D

    var id: UUID { get }

    init(properties: P, dependency: D, id: UUID)
}

public extension ComponentViewModel {
    init(any: Any, dependency: Any, id: UUID) {
        self.init(properties: any as! P,
                  dependency: dependency as! D,
                  id: id)
    }
}
