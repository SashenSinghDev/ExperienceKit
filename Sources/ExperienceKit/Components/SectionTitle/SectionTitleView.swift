//
//  SectionTitleView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/07/2025.
//

import Foundation
import SwiftUI

struct SectionTitleView: ComponentView {

    @ObservedObject var viewModel: SectionTitleViewModel

    init(viewModel: SectionTitleViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Text(viewModel.title)
                .font(.title2)
                .bold()
            Spacer()
        }
        .padding(.horizontal, .spacing.medium)
        .padding(.vertical, .spacing.small)
    }
}

extension SectionTitleView {
    static func == (lhs: SectionTitleView, rhs: SectionTitleView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
