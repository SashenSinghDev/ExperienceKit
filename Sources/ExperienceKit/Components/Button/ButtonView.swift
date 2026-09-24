//
//  ButtonView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 16/02/2025.
//

import Foundation
import SwiftUI

struct ButtonView: ComponentView {

    var viewModel: ButtonViewModel

    init(viewModel: ButtonViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Button {
            viewModel.navigate()
        } label: {
            Text(viewModel.title)
                .font(.body.weight(.semibold))
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.style.backgroundColor)
                .foregroundColor(viewModel.style.labelColor)
                .cornerRadius(.radius.full)
                .overlay(
                    RoundedRectangle(cornerRadius: .radius.full)
                        .strokeBorder(viewModel.style.borderColor, lineWidth: 1)
                )
        }
    }
}

extension ButtonView {
    static func == (lhs: ButtonView, rhs: ButtonView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}

private extension ButtonProperties.Style {
    var backgroundColor: Color {
        switch self {
        case .primary:
            return .button.primary.background
        case .secondary:
            return .button.secondary.background
        case .borderless:
            return .clear
        }
    }

    var labelColor: Color {
        switch self {
        case .primary:
            return .button.primary.label
        case .secondary, .borderless:
            return .button.secondary.label
        }
    }

    var borderColor: Color {
        switch self {
        case .primary, .borderless:
            return .clear
        case .secondary:
            return .button.secondary.border
        }
    }
}
