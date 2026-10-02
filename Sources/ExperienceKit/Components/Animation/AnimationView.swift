import SwiftUI

struct AnimationView: ComponentView {
    @ObservedObject var viewModel: AnimationViewModel

    init(viewModel: AnimationViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .frame(width: width,
                   height: height)
            .clipped()
    }

    @ViewBuilder
    private var content: some View {
        if let animationView = viewModel.animationView() {
            animationView
        } else {
            // No provider, or an animation the provider does not recognise:
            // keep the layout space and draw nothing.
            Color.clear
        }
    }

    private var width: CGFloat? {
        guard let width = viewModel.width else { return nil }
        return CGFloat(width)
    }

    private var height: CGFloat? {
        guard let height = viewModel.height else { return nil }
        return CGFloat(height)
    }
}

extension AnimationView {
    static func == (lhs: AnimationView, rhs: AnimationView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
