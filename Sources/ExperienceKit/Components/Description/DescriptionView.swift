//
//  DescriptionView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 01/01/2025.
//

import Foundation
import SwiftUI

struct DescriptionView: ComponentView {

    @ObservedObject var viewModel: DescriptionViewModel

    init(viewModel: DescriptionViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 24.0) {
            switch viewModel.style {
            case .regular(let theme):
                Text(viewModel.title)
                    .font(.h3)
                    .foregroundStyle(theme == .regular ? .black : .white)
                Text(viewModel.subtitle)
                    .font(.bodyXLargeRegular)
                    .foregroundStyle(theme == .regular ? .black : .white)
            case .large(let theme):
                Text(viewModel.title)
                    .font(.h1)
                    .foregroundStyle(theme == .regular ? .black : .white)
                Text(viewModel.subtitle)
                    .font(.bodyXLargeSemiBold)
                    .foregroundStyle(theme == .regular ? .black : .white)
            }
        }
    }
}

extension DescriptionView {
    static func == (lhs: DescriptionView, rhs: DescriptionView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
