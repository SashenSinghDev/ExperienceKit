import SwiftUI

struct ContainerView: ComponentView {
    @ObservedObject var viewModel: ContainerViewModel

    init(viewModel: ContainerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text("\(viewModel.title)")
    }
}

extension ContainerView {
    static func == (lhs: ContainerView, rhs: ContainerView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
