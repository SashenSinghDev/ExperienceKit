//
//  SeparatorView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 25/07/2025.
//

import Foundation
import SwiftUI

struct SeparatorView: ComponentView {

    @ObservedObject var viewModel: SeparatorViewModel

    init(viewModel: SeparatorViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Rectangle()
            .fill(Color.gray)
            .opacity(0.25)
            .frame(height: 1)
            .padding(.leading, viewModel.isFullWidth ? .spacing.none: .spacing.medium)
    }
}

extension SeparatorView {
    static func == (lhs: SeparatorView, rhs: SeparatorView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
