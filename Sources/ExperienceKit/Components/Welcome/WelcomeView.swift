//
//  WelcomeView.swift
//
//
//  Created by Sashen Singh on 25/10/2024.
//

import Foundation
import SwiftUI

struct WelcomeView: ComponentView {

    @ObservedObject var viewModel: WelcomeViewModel

    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image(viewModel.image.uri,
                      bundle: .init(identifier: viewModel.image.bundle))
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped() // Ensures no overflow
            }
            .edgesIgnoringSafeArea(.all)

            LinearGradient(
                gradient: Gradient(colors: [Color.clear,
                                            Color(red: 58/255, green: 58/255, blue: 58/255),
                                            Color(red: 118/255, green: 118/255, blue: 118/255)]),
                startPoint: .center,
                endPoint: .bottom
            )

            VStack {
                Spacer()

                VStack(spacing: 36) {
                    DescriptionView(viewModel: viewModel.description)
                        .frame(maxWidth: .infinity, alignment: .leading)


                    VStack(spacing: 12) {
                        ButtonView(viewModel: viewModel.primaryButton)

                        if let secondaryButtonViewModel = viewModel.secondaryButton {
                            ButtonView(viewModel: secondaryButtonViewModel)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .safeAreaPadding(.bottom, 36)
            }
        }

    }
}

extension WelcomeView {
    static func == (lhs: WelcomeView, rhs: WelcomeView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
