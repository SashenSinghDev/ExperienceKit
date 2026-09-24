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
        HStack(spacing: .spacing.medium) {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(viewModel.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: .spacing.small)

            indicator
        }
        .padding(.spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: .radius.md)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: .radius.md)
                .strokeBorder(Color(.separator), lineWidth: 1)
        )
        .contentShape(Rectangle())
    }

    private var indicator: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .strokeBorder(viewModel.isSelected ? Color.clear : Color(.separator), lineWidth: 2)
                .background(Circle().fill(viewModel.isSelected ? Color.accentColor : Color.clear))
                .frame(width: 24, height: 24)
                .overlay {
                    if viewModel.isSelected {
                        Circle().fill(.white).frame(width: 8, height: 8)
                    }
                }

            if viewModel.showBadge {
                Circle()
                    .fill(.red)
                    .frame(width: 8, height: 8)
                    .overlay(Circle().strokeBorder(.white, lineWidth: 1.5))
            }
        }
        .frame(width: 28, height: 28, alignment: .topLeading)
    }
}

extension SelectionCardView {
    static func == (lhs: SelectionCardView, rhs: SelectionCardView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id &&
        lhs.viewModel.isSelected == rhs.viewModel.isSelected &&
        lhs.viewModel.showBadge == rhs.viewModel.showBadge
    }
}
