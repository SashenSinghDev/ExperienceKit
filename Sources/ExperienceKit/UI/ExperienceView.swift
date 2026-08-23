//
//  ExperienceView.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import SwiftUI

public struct ExperienceView<Presenter>: View where Presenter: ExperiencePresenter {

    @StateObject private var presenter: Presenter
    @StateObject private var router: DefaultExperienceRouter

    private let viewProvider: ViewProvider

    public init(presenter: Presenter,
                viewProvider: ViewProvider,
                router: DefaultExperienceRouter) {
        _presenter = StateObject(wrappedValue: presenter)
        self.viewProvider = viewProvider
        self._router = StateObject(wrappedValue: router) // underscore version for init
    }

    public var body: some View {
        let navigationBarPresentation = NavigationBarPresentation(navigationBarModel: presenter.navigationBarModel)

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
                        VStack(spacing: 0) {
                            ForEach(viewModel) { viewModel in
                                makeView(from: viewModel)
//                                    .buttonStyle(StaticButtonStyle())
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                case .loadedFullScreen(let viewModel):
                    VStack {
                        makeView(from: viewModel)
                    }
//                    .ignoresSafeArea()
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
        .modifier(
            AnyViewModifier { view in
                if let searchBarModel = presenter.navigationBarModel?.searchBar {
                    return AnyView(
                        view.searchable(
                            text: $presenter.searchText,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: searchBarModel.placeholder
                        )
                    )
                } else {
                    return view
                }
            }
        )
        .navigationTitle(navigationBarPresentation.title)
        .navigationBarTitleDisplayMode(navigationBarPresentation.displayMode.swiftUIDisplayMode)
        .animation(.easeInOut, value: router.isLoading)
    }

    @ViewBuilder
    private func makeView(from component: AnyComponentViewModel) -> some View {
        viewProvider.view(for: component)
    }
}

private extension NavigationBarPresentation.DisplayMode {
    var swiftUIDisplayMode: NavigationBarItem.TitleDisplayMode {
        switch self {
        case .automatic:
            return .automatic
        case .inline:
            return .inline
        case .large:
            return .large
        }
    }
}

private struct AnyViewModifier: ViewModifier {
    let transform: (AnyView) -> AnyView

    func body(content: Content) -> some View {
        transform(AnyView(content))
    }
}
