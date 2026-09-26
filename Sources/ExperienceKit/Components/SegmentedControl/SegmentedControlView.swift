import SwiftUI

struct SegmentedControlView: ComponentView {
    @ObservedObject var viewModel: SegmentedControlViewModel
    @State private var selectedValue: String

    init(viewModel: SegmentedControlViewModel) {
        self.viewModel = viewModel
        self._selectedValue = State(initialValue: viewModel.selectedValue)
    }

    var body: some View {
        Picker(viewModel.accessibilityLabel, selection: $selectedValue) {
            ForEach(viewModel.options, id: \.value) { option in
                Text(option.label)
                    .tag(option.value)
            }
        }
        .pickerStyle(.segmented)
        .tint(.surface.primary)
        .onChange(of: selectedValue) { _, newValue in
            viewModel.selectValue(newValue)
        }
        .onReceive(viewModel.$selectedValue) { newValue in
            guard selectedValue != newValue else {
                return
            }

            selectedValue = newValue
        }
    }
}

extension SegmentedControlView {
    static func == (lhs: SegmentedControlView, rhs: SegmentedControlView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id &&
        lhs.viewModel.options == rhs.viewModel.options &&
        lhs.selectedValue == rhs.selectedValue
    }
}
