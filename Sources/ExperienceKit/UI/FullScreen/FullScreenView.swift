import SwiftUI

struct FullScreenView: View, Equatable {
    @ObservedObject var viewModel: FullScreenViewModel

    init(viewModel: FullScreenViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            if let backgroundImage = viewModel.image {
                Image(backgroundImage.uri,
                      bundle: .init(identifier: backgroundImage.bundle))
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }

            // Top content scrolls, so when the keyboard opens and the bottom bar
            // rises it scrolls out of the way instead of sitting underneath it.
            if !viewModel.topAnyComponentViewModels.isEmpty {
                ScrollView {
                    VStack(spacing: .spacing.none) {
                        ForEach(viewModel.topAnyComponentViewModels) { viewModel in
                            makeView(from: viewModel)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .scrollBounceBehavior(.basedOnSize)
                .scrollDismissesKeyboard(.interactively)
            }

            if !viewModel.middleAnyComponentViewModels.isEmpty {
                VStack(spacing: .spacing.none) {
                    Spacer()
                    ForEach(viewModel.middleAnyComponentViewModels) { viewModel in
                        makeView(from: viewModel)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        // Fill the screen even when there is no top or middle content (e.g. a
        // welcome screen with only bottom components), so the bar pins to the
        // bottom edge rather than to an empty, zero-height stack.
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Bottom content (e.g. a Continue button) is pinned as a bar rather than
        // overlaid in the ZStack. SwiftUI reserves its height in the safe area, so
        // the top ScrollView stops above it, and the bar still rides up with the
        // keyboard. Scroll content passing under it gets the system scroll edge effect.
        .safeAreaBar(edge: .bottom, spacing: .spacing.none) {
            if !viewModel.bottomAnyComponentViewModels.isEmpty {
                VStack(spacing: .spacing.none) {
                    ForEach(viewModel.bottomAnyComponentViewModels) { viewModel in
                        makeView(from: viewModel)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func makeView(from component: AnyComponentViewModel) -> some View {
        viewModel.viewProvider.view(for: component)
    }
}

extension FullScreenView {
    static func == (lhs: FullScreenView, rhs: FullScreenView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
