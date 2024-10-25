//
//  ExampleComponentView.swift
//
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import SwiftUI

struct ExampleComponentView: ComponentView {

    @ObservedObject var viewModel: ExampleViewModel

    init(viewModel: ExampleViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        TextEditor(text: $viewModel.profileText)
            .foregroundStyle(.black)
            .padding(.horizontal, 16)
            .frame(height: 30)

        Picker(selection: $viewModel.publishedAmount, label: Text("Amount")) {
            Text("€1").tag(1)
            Text("€2").tag(2)
            Text("€3").tag(3)
            Text("€4").tag(4)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 16)

        NavigationLink(value: viewModel) {
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
            .padding(.horizontal, 16)
            .background(.white)
            .cornerRadius(8)
            Button(action: {
                print(viewModel.publishedAmount)
            }, label: {
                Text("get picker value")
                    .frame(maxWidth: .infinity)
            })
            .padding(.horizontal, 16)
            .buttonStyle(SecondaryButtonStyle())
        }
    }
}

extension ExampleComponentView {
    static func == (lhs: ExampleComponentView, rhs: ExampleComponentView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id &&
        lhs.viewModel.publishedAmount == rhs.viewModel.publishedAmount
    }
}
