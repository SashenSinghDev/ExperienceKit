import SwiftUI

struct SegmentedControlView: ComponentView {
    private enum Constant {
        static let trackInset: CGFloat = 1
        static let segmentMinimumHeight: CGFloat = 44
        static let strokeWidth: CGFloat = 1
    }

    @ObservedObject var viewModel: SegmentedControlViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var selectedSegment
    @State private var selectedValue: String

    init(viewModel: SegmentedControlViewModel) {
        self.viewModel = viewModel
        self._selectedValue = State(initialValue: viewModel.selectedValue)
    }

    var body: some View {
        HStack(spacing: .spacing.none) {
            ForEach(viewModel.options, id: \.value) { option in
                button(for: option)
            }
        }
        .padding(Constant.trackInset)
        .overlay(
            Capsule()
                .strokeBorder(.separators.nonOpaque, lineWidth: Constant.strokeWidth)
        )
        .clipShape(Capsule())
        .accessibilityElement(children: .contain)
        .accessibilityLabel(viewModel.accessibilityLabel)
        .animation(reduceMotion ? nil : .snappy, value: selectedValue)
        .onReceive(viewModel.$selectedValue) { newValue in
            guard selectedValue != newValue else {
                return
            }

            selectedValue = newValue
        }
    }

    private func button(for option: SegmentedControlProperties.Option) -> some View {
        let isSelected = selectedValue == option.value

        return Button {
            select(option)
        } label: {
            Text(option.label)
                .font(.footnote)
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundStyle(isSelected ? Color.text.primary : .labels.primary)
                .padding(.horizontal, .spacing.small)
                .frame(maxWidth: .infinity, minHeight: Constant.segmentMinimumHeight)
                .background {
                    if isSelected {
                        Capsule()
                            .fill(.surface.primary)
                            .matchedGeometryEffect(id: "selectedSegment", in: selectedSegment)
                            .allowsHitTesting(false)
                    }
                }
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func select(_ option: SegmentedControlProperties.Option) {
        guard selectedValue != option.value else {
            return
        }

        selectedValue = option.value
        viewModel.select(option)
    }
}

extension SegmentedControlView {
    static func == (lhs: SegmentedControlView, rhs: SegmentedControlView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id &&
        lhs.viewModel.options == rhs.viewModel.options &&
        lhs.selectedValue == rhs.selectedValue
    }
}
