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

    public init(registers: [ComponentRegister]) {
        self.registers = registers
    }

    public func view(for viewModel: AnyComponentViewModel, presenter: ExperiencePresenter) -> some View {
        for register in registers where viewModel.contentType == register.contentType {
            guard let viewModel = viewModel.value as? (any ComponentViewModel) else {
                continue
            }
            let view = register.view(from: viewModel, presenter: presenter)
            return view
        }
        fatalError("Not implemented!")
    }
}
