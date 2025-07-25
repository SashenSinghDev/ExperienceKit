//
//  GenericListItemView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 12/07/2025.
//

import Foundation
import SwiftUI

struct GenericListItemView: ComponentView {

    @ObservedObject var viewModel: GenericListItemViewModel

    init(viewModel: GenericListItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if viewModel.navigationViewModel != nil {
            Button {
                viewModel.navigate()
            } label: {
                HStack {
                    Text(viewModel.title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray) 
                }
                .padding(16)
                .frame(maxWidth: .infinity) // Make the HStack fill available width
                .contentShape(Rectangle())
            }
            .buttonStyle(HighlightButtonStyle())
        } else {
            HStack {
                Text(viewModel.title)
                    .font(.headline)
                Spacer()
            }
            .padding(16)
        }
    }
}

struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.gray.opacity(0.2) : Color.clear)
            .cornerRadius(8)
    }
}

extension GenericListItemView {
    static func == (lhs: GenericListItemView, rhs: GenericListItemView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
