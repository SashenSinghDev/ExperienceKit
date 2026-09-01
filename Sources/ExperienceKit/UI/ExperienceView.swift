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
        let navigationBarPresentation = NavigationBarPresentation(experienceViewModel: presenter.experienceViewModel)

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
                        .padding(.bottom, searchBarReservedHeight)
                    }
                case .loadedFullScreen(let viewModel):
                    VStack {
                        FullScreenView(viewModel: viewModel)
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

            if let searchBarModel = presenter.experienceViewModel?.searchBar {
                VStack {
                    Spacer()

                    BottomSearchBar(
                        text: Binding(
                            get: { presenter.searchText },
                            set: { presenter.searchText = $0 }
                        ),
                        placeholder: searchBarModel.placeholder,
                        navigationPathCount: router.path.count
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(navigationBarPresentation.title)
        .navigationBarTitleDisplayMode(navigationBarPresentation.displayMode.swiftUIDisplayMode)
        .animation(.easeInOut, value: router.isLoading)
    }

    @ViewBuilder
    private func makeView(from component: AnyComponentViewModel) -> some View {
        viewProvider.view(for: component)
    }

    private var searchBarReservedHeight: CGFloat {
        presenter.experienceViewModel?.searchBar == nil ? 0 : 92
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

private struct BottomSearchBar: View {
    @Binding var text: String
    var placeholder: String
    var navigationPathCount: Int

    @FocusState private var isSearchFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(.primary)

            TextField(placeholder, text: $text)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(.primary)
                .submitLabel(.search)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isSearchFocused)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 18)
        .liquidGlassSearchBackground()
        .overlay {
            Capsule()
                .strokeBorder(.white.opacity(0.35), lineWidth: 0.5)
        }
        .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .onDisappear {
            isSearchFocused = false
        }
        .onChange(of: navigationPathCount) { _, _ in
            isSearchFocused = false
        }
    }
}

private extension View {
    func liquidGlassSearchBackground() -> some View {
        self.glassEffect(.regular, in: .capsule)
    }
}
