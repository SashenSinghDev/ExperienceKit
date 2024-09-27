//
//  ExperienceView.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import SwiftUI

public struct ExperienceView: View {

    @ObservedObject var presenter: DefaultExperiencePresenter
    private let viewProvider: ViewProvider

    public init(presenter: DefaultExperiencePresenter,
                viewProvider: ViewProvider) {
        self.presenter = presenter
        self.viewProvider = viewProvider
    }

    public var body: some View {
        switch presenter.state {
        case .idle:
            // Render a clear color and start the loading process
            // when the view first appears, which should make the
            // view model transition into its loading state:
            Color.clear.onAppear(perform: presenter.load)
        case .loading:
            ProgressView()
        case .failed(let error):
            Color.clear.onAppear(perform: presenter.load)
        case .loaded(let viewModel):
            ScrollView {
                VStack {
                    ForEach(viewModel) { viewModel in
                        makeView(from: viewModel)
                    }
                }
                Spacer()
            }
            .padding()
        }
    }


    @ViewBuilder
    private func makeView(from component: AnyComponentViewModel) -> some View {
        viewProvider.view(for: component, presenter: presenter)
    }
}
