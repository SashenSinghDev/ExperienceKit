//
//  ExampleComponentView.swift
//
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import SwiftUI

struct ExampleComponentView: View, ComponentView {

    private let viewModel: ExampleViewModel

    init(viewModel: ExampleViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .leading) {
            Text("Title")
                .bold()
            Text("\(viewModel.title)")
        }
        .padding()
        .background(.green)
        .cornerRadius(8)
    }

}
