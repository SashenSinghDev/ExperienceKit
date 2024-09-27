//
//  ExampleComponentView.swift
//
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import SwiftUI

struct ExampleComponentView: ComponentView {

    private let presenter: ExperiencePresenter
    @ObservedObject var viewModel: ExampleViewModel

    init(viewModel: ExampleViewModel, 
         presenter: ExperiencePresenter) {
        self.viewModel = viewModel
        self.presenter = presenter
    }

    var body: some View {
        TextEditor(text: $viewModel.profileText)
            .foregroundStyle(.black)
            .padding(.horizontal)
            .frame(height: 30)

        Picker(selection: $viewModel.publishedAmount, label: Text("Amount")) {
            Text("€1").tag(1)
            Text("€2").tag(2)
            Text("€5").tag(5)
            Text("€10").tag(10)
        }
        .pickerStyle(SegmentedPickerStyle())

        NavigationLink(value: viewModel) {
            VStack(alignment: .leading) {
                Text("Title")
                    .bold()
                Text("\(viewModel.title)")
                Link(destination: URL(string: "https://www.google.com/?client=safari")!) {
                    Text("UrlLink")
                }
                Button(action: {
                    print(viewModel.publishedAmount)
                }, label: {
                    Text("get picker value")
                })
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
