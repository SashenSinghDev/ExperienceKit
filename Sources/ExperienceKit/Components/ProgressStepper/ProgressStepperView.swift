import SwiftUI

struct ProgressStepperView: ComponentView {
    private enum Constant {
        static let segmentHeight: CGFloat = 4
        static let segmentSpacing: CGFloat = 6
        static let segmentCornerRadius: CGFloat = 2
    }

    @ObservedObject var viewModel: ProgressStepperViewModel

    init(viewModel: ProgressStepperViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(spacing: Constant.segmentSpacing) {
            ForEach(0..<viewModel.totalSteps, id: \.self) { index in
                RoundedRectangle(cornerRadius: Constant.segmentCornerRadius)
                    .fill(segmentColor(for: index))
                    .frame(maxWidth: .infinity)
                    .frame(height: Constant.segmentHeight)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("Step \(viewModel.currentStep) of \(viewModel.totalSteps)")
    }

    private func segmentColor(for index: Int) -> Color {
        index < viewModel.currentStep ? .progressStepper.activeSegment : .progressStepper.inactiveSegment
    }
}

extension ProgressStepperView {
    static func == (lhs: ProgressStepperView, rhs: ProgressStepperView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id &&
        lhs.viewModel.currentStep == rhs.viewModel.currentStep &&
        lhs.viewModel.totalSteps == rhs.viewModel.totalSteps
    }
}
