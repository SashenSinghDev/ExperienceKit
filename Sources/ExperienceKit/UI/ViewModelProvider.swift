//
//  File.swift
//  
//
//  Created by Sashen Singh on 08/06/2024.
//

import Foundation

public protocol ViewModelProvider {
    func viewModel(for content: Component, dependency: ExperienceDependency) -> AnyComponentViewModel?
}

public final class DefaultViewModelProvider: ViewModelProvider {
    private let registers: [ComponentRegister]

    public init(supportedComponentRegisters: [ComponentRegister]) {
        self.registers = supportedComponentRegisters
    }

    public func viewModel(for content: Component, dependency: ExperienceDependency) -> AnyComponentViewModel? {
        for register in registers where register.contentType == content.contentType {
            return register.viewModel(from: content, dependency: dependency)
        }

        return nil
    }
}
