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
        case .borderless, .glass, .glassProminent:
            return .clear
        }
    }

    /// Figma: Glass → color/labels-vibrant/primary (the vibrant label role for content on
    /// materials); Glass Prominent → color/grays/white on the accent tint.
    var labelColor: Color {
        switch self {
        case .primary:
            return .button.primary.label
        case .secondary, .borderless:
            return .button.secondary.label
        case .glass:
            return .labelsVibrant.primary
        case .glassProminent:
            return .grays.white
        }
    }

    var borderColor: Color {
        switch self {
        case .primary, .borderless, .glass, .glassProminent:
            return .clear
        case .secondary:
            return .button.secondary.border
        }
    }
}

private extension View {
    /// Applies the pill surface for a button style.
    /// Glass uses the native, untinted Liquid Glass material (Figma: Material/Liquid Glass);
    /// the glass edge highlight replaces the border. Per the HIG, Liquid Glass has no colour
    /// of its own and tint is reserved for emphasising a primary action, so the default glass
    /// button stays untinted. Glass Prominent tints the glass with `color/accents/blue`, mirroring
    /// the system `.glassProminent` style: colour on the background, not the label.
    @ViewBuilder
    func buttonSurface(for style: ButtonProperties.Style) -> some View {
        switch style {
        case .glass:
            self
                .contentShape(.capsule)
                .glassEffect(.regular.interactive(), in: .capsule)
        case .glassProminent:
            self
                .contentShape(.capsule)
                .glassEffect(.regular.tint(.accents.blue).interactive(), in: .capsule)
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
