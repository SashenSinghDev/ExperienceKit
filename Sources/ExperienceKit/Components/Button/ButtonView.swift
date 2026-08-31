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
                .background(viewModel.style == .primary ? .button.primary.background : .button.secondary.background)
                .foregroundColor(viewModel.style == .primary ? .button.primary.label : .button.secondary.label)
                .cornerRadius(.radius.full)
                .overlay(
                    RoundedRectangle(cornerRadius: .radius.full)
                        .strokeBorder(viewModel.style == .secondary ? .button.secondary.border : .clear, lineWidth: 1)
                )
        }
        .padding(.horizontal, viewModel.isFullWidth ? .spacing.none : .spacing.medium)
    }
}

extension ButtonView {
    static func == (lhs: ButtonView, rhs: ButtonView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
