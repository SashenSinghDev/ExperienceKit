import SwiftUI

struct HorizontalStackView: ComponentView {
    @ObservedObject var viewModel: HorizontalStackViewModel

    init(viewModel: HorizontalStackViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text("\(viewModel.title)")
    }
}

extension HorizontalStackView {
    static func == (lhs: HorizontalStackView, rhs: HorizontalStackView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
