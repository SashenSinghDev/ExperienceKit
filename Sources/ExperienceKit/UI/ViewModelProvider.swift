//
//  File.swift
//  
//
//  Created by Sashen Singh on 08/06/2024.
//

import Foundation

public protocol ViewModelProvider {
    func viewModel(for content: Component) -> AnyComponentViewModel?
}

public final class DefaultViewModelProvider: ViewModelProvider {
    private let registers: [ComponentRegister]
    private let dependency: ExperienceDependency

    public init(supportedComponentRegisters: [ComponentRegister], dependency: ExperienceDependency) {
        self.registers = supportedComponentRegisters
        self.dependency = dependency
    }

    public func viewModel(for content: Component) -> AnyComponentViewModel? {
        for register in registers where register.contentType == content.contentType {
            return register.viewModel(from: content, dependency: dependency)
        }

        return nil
    }
}
