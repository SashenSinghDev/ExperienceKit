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
        NavigationLink(destination: Text("Test")) {
            VStack(alignment: .leading) {
                Text("Title")
                    .bold()
                Text("\(viewModel.title)")
                Link(destination: URL(string: "https://www.google.com/?client=safari")!) {
                    Text("UrlLink")
                }
            }
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .padding()
            .background(.green)
            .cornerRadius(8)
        }
        .buttonStyle(StaticButtonStyle())
    }
}
