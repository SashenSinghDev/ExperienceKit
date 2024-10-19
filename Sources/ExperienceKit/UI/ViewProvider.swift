//
//  ViewProvider.swift
//
//
//  Created by Sashen Singh on 08/06/2024.
//

import Foundation
import SwiftUI

public final class ViewProvider {

    private let registers: [ComponentRegister]

    public init(supportedComponentRegisters: [ComponentRegister]) {
        self.registers = supportedComponentRegisters
    }

    public func view(for viewModel: AnyComponentViewModel) -> some View {
        for register in registers where viewModel.contentType == register.contentType {
            guard let viewModel = viewModel.value as? (any ComponentViewModel) else {
                continue
            }
            let view = register.view(from: viewModel)
            return view
        }
        fatalError("Not implemented!")
    }
}
