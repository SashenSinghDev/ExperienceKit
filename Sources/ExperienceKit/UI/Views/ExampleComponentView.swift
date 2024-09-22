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
    private let presenter: ExperiencePresenter

    init(viewModel: ExampleViewModel, presenter: ExperiencePresenter) {
        self.viewModel = viewModel
        self.presenter = presenter
    }

    var body: some View {
        NavigationLink(destination: presenter.navigate(viewModel.id)) {
            VStack(alignment: .leading) {
                Text("Title")
                    .bold()
                Text("\(viewModel.title)")
                Link(destination: URL(string: "https://www.google.com/?client=safari")!) {
                    Text("UrlLink")
                }
                Button(action: {

                }, label: {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
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
