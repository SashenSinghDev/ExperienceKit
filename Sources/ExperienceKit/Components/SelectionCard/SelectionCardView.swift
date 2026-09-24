//
//  SelectionCardView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/09/2026.
//

import Foundation
import SwiftUI

struct SelectionCardView: ComponentView {

    @ObservedObject var viewModel: SelectionCardViewModel

    init(viewModel: SelectionCardViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if viewModel.navigationViewModel != nil {
            Button {
                viewModel.select()
            } label: {
                content
            }
            .buttonStyle(.plain)
        } else {
            content
        }
    }

    private var content: some View {
        HStack(spacing: .spacing.small) {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.title)
                    .font(.headline)
                    .foregroundStyle(Color(.label))
                Text(viewModel.subtitle)
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let badgeText = viewModel.badgeText {
                Text(badgeText)
                    .font(.caption2)
                    .foregroundStyle(Color(.systemBackground))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(Color(.label))
                    )
            }

            Text(viewModel.value)
                .font(.body)
                .foregroundStyle(Color(.label))
        }
        .padding(.spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: .radius.lg)
                .fill(viewModel.isSelected ? Color(.secondarySystemBackground) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: .radius.lg)
                .strokeBorder(viewModel.isSelected ? Color(.label) : Color(.opaqueSeparator), lineWidth: 1)
        )
        .contentShape(Rectangle())
    }
}

extension SelectionCardView {
    static func == (lhs: SelectionCardView, rhs: SelectionCardView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id &&
        lhs.viewModel.value == rhs.viewModel.value &&
        lhs.viewModel.isSelected == rhs.viewModel.isSelected &&
        lhs.viewModel.badgeText == rhs.viewModel.badgeText
    }
}
