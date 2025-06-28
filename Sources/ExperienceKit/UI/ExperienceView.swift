//
//  ExperienceView.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import SwiftUI

public struct ExperienceView<Presenter>: View where Presenter: ExperiencePresenter {

    @StateObject private var presenter: Presenter
    @StateObject private var router: NavigationRouter

    private let viewProvider: ViewProvider

    public init(presenter: Presenter,
                viewProvider: ViewProvider,
                router: NavigationRouter) {
        _presenter = StateObject(wrappedValue: presenter)
        self.viewProvider = viewProvider
        self._router = StateObject(wrappedValue: router) // underscore version for init
    }

    public var body: some View {
        ZStack {
            VStack {
                switch presenter.state {
                case .idle:
                    // Render a clear color and start the loading process
                    // when the view first appears, which should make the
                    // view model transition into its loading state:
                    Color.clear.onAppear(perform: presenter.load)
                case .loading:
                    ProgressView()
                case .failed(_):
                    Color.clear.onAppear(perform: presenter.load)
                case .loadedScrollable(let viewModel):
                    ScrollView {
                        VStack {
                            ForEach(viewModel) { viewModel in
                                makeView(from: viewModel)
                                    .buttonStyle(StaticButtonStyle())
                            }
                        }
                    }
                case .loadedScrollableWithNavigationBar(let viewModel, let navigationTitle):
                    ScrollView {
                        VStack {
                            ForEach(viewModel) { viewModel in
                                makeView(from: viewModel)
                                    .buttonStyle(StaticButtonStyle())
                            }
                        }
                        .navigationTitle(navigationTitle)
                        .navigationBarTitleDisplayMode(.inline) // Use inline to reduce top spacing
                    }
                case .loadedFullScreen(let viewModel):
                    VStack {
                        makeView(from: viewModel)
                    }
                    .ignoresSafeArea()
                }
            }

            if router.isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                ProgressView("Loading...")
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
            }
        }
        .animation(.easeInOut, value: router.isLoading)
    }

    @ViewBuilder
    private func makeView(from component: AnyComponentViewModel) -> some View {
        viewProvider.view(for: component)
    }
}
