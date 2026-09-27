import SwiftUI

struct ValidationMessageView: ComponentView {
    @ObservedObject var viewModel: ValidationMessageViewModel

    init(viewModel: ValidationMessageViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if let message = viewModel.message {
            Text(message)
                .font(.footnote)
                .foregroundStyle(Color.accents.red)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                // Figma: 8pt between the fields and their error. Owned here so the
                // gap disappears with the message instead of leaving a spacer behind.
                .padding(.top, .spacing.small)
                .accessibilityLabel(message)
        }
    }
}

extension ValidationMessageView {
    static func == (lhs: ValidationMessageView, rhs: ValidationMessageView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
