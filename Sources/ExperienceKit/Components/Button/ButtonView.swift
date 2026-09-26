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
                .foregroundColor(viewModel.style.labelColor)
                .buttonSurface(for: viewModel.style)
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
        case .borderless, .glass:
            return .clear
        }
    }

    var labelColor: Color {
        switch self {
        case .primary:
            return .button.primary.label
        case .secondary, .borderless, .glass:
            return .button.secondary.label
        }
    }

    var borderColor: Color {
        switch self {
        case .primary, .borderless, .glass:
            return .clear
        case .secondary:
            return .button.secondary.border
        }
    }
}

private extension View {
    /// Applies the pill surface for a button style.
    /// Glass uses the native Liquid Glass material (Figma: Material/Liquid Glass) tinted with
    /// `color/button/glassTint`; the glass edge highlight replaces the border.
    @ViewBuilder
    func buttonSurface(for style: ButtonProperties.Style) -> some View {
        switch style {
        case .glass:
            self
                .contentShape(.capsule)
                .glassEffect(.regular.tint(Color.button.glass.tint).interactive(), in: .capsule)
        case .primary, .secondary, .borderless:
            self
                .background(style.backgroundColor)
                .cornerRadius(.radius.full)
                .overlay(
                    RoundedRectangle(cornerRadius: .radius.full)
                        .strokeBorder(style.borderColor, lineWidth: 1)
                )
        }
    }
}
