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

            if !viewModel.topAnyComponentViewModels.isEmpty {
                VStack(spacing: .spacing.none) {
                    ForEach(viewModel.topAnyComponentViewModels) { viewModel in
                        makeView(from: viewModel)
                    }
                    Spacer()
                }
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

            if !viewModel.bottomAnyComponentViewModels.isEmpty {
                VStack(spacing: .spacing.none) {
                    Spacer()
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
