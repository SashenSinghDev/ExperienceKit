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
        Image(viewModel.image.uri, 
              bundle: .init(identifier: viewModel.image.bundle))
    }
}

extension WelcomeView {
    static func == (lhs: WelcomeView, rhs: WelcomeView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
