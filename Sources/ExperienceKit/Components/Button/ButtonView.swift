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
                .font(.bodyLargeBold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.style == .primary ? .black : .white)
                .foregroundColor(viewModel.style == .primary ? .white : .black)
                .cornerRadius(100)
        }
    }
}

extension ButtonView {
    static func == (lhs: ButtonView, rhs: ButtonView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
