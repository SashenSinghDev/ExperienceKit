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
        Button {
            viewModel.select()
        } label: {
            content
        }
        .buttonStyle(.plain)
    }

    private var content: some View {
        layout
            .padding(.spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: .radius.lg)
                    .fill(viewModel.isSelected ? Color.grays.gray5 : Color.backgrounds.primary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: .radius.lg)
                    .strokeBorder(viewModel.isSelected ? Color.surface.primary : Color.separators.opaque,
                                  lineWidth: 1)
            )
            .contentShape(Rectangle())
    }

    @ViewBuilder
    private var layout: some View {
        if let value = viewModel.value {
            // Plan picker: badge + value vertically centred beside the text stack.
            HStack(spacing: .spacing.small) {
                VStack(alignment: .leading, spacing: 2) {
                    title
                    subtitle
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                badge

                Text(value)
                    .font(.body)
                    .foregroundStyle(Color.labels.primary)
            }
        } else {
            // Choice card: badge on the title row, subtitle full width below.
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: .spacing.small) {
                    title
                        .frame(maxWidth: .infinity, alignment: .leading)
                    badge
                }
                subtitle
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var title: some View {
        Text(viewModel.title)
            .font(.headline)
            .foregroundStyle(Color.labels.primary)
            .lineLimit(1)
    }

    private var subtitle: some View {
        Text(viewModel.subtitle)
            .font(.footnote)
            .foregroundStyle(Color.labels.secondary)
            .multilineTextAlignment(.leading)
    }

    @ViewBuilder
    private var badge: some View {
        if let badgeText = viewModel.badgeText {
            Text(badgeText)
                .font(.caption2)
                .foregroundStyle(badgeLabelColor)
                .lineLimit(1)
                .fixedSize()
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(badgeFillColor)
                )
        }
    }

    private var badgeFillColor: Color {
        switch viewModel.badgeStyle {
        case .prominent:
            return Color.surface.primary
        case .neutral:
            return Color.fills.tertiary
        }
    }

    private var badgeLabelColor: Color {
        switch viewModel.badgeStyle {
        case .prominent:
            return Color.text.primary
        case .neutral:
            return Color.labels.primary
        }
    }
}

extension SelectionCardView {
    static func == (lhs: SelectionCardView, rhs: SelectionCardView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id &&
        lhs.viewModel.title == rhs.viewModel.title &&
        lhs.viewModel.subtitle == rhs.viewModel.subtitle &&
        lhs.viewModel.value == rhs.viewModel.value &&
        lhs.viewModel.isSelected == rhs.viewModel.isSelected &&
        lhs.viewModel.badgeText == rhs.viewModel.badgeText &&
        lhs.viewModel.badgeStyle == rhs.viewModel.badgeStyle
    }
}
