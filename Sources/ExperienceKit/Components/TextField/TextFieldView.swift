import SwiftUI
import UIKit

struct TextFieldView: ComponentView {
    @ObservedObject var viewModel: TextFieldViewModel
    @FocusState private var isFocused: Bool
    @State private var text: String

    init(viewModel: TextFieldViewModel) {
        self.viewModel = viewModel
        self._text = State(initialValue: viewModel.text)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.small) {
            if let label = viewModel.label {
                Text(label)
                    .font(.footnote)
                    .foregroundStyle(labelColor)
                    .lineLimit(1)
            }

            HStack(spacing: .spacing.small) {
                if let leadingSystemImage = viewModel.leadingSystemImage {
                    Image(systemName: leadingSystemImage)
                        .font(.body)
                        .foregroundStyle(symbolColor)
                }

                field
                    .font(.body)
                    .lineLimit(1)
                    .foregroundStyle(valueColor)
                    .tint(caretColor)
                    .focused($isFocused)
                    .disabled(viewModel.isDisabled)
                    .keyboardType(viewModel.keyboardType.uiKeyboardType)
                    .accessibilityLabel(viewModel.accessibilityLabel)

                if let unit = viewModel.unit {
                    Text(unit)
                        .font(.body)
                        .foregroundStyle(symbolColor)
                        .lineLimit(1)
                }

                if shouldShowClearButton {
                    Button {
                        text = ""
                        viewModel.updateText("")
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.body)
                            .foregroundStyle(clearButtonColor)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear \(viewModel.accessibilityLabel)")
                    .disabled(viewModel.isDisabled)
                }
            }
            .padding(.horizontal, .spacing.medium)
            .padding(.vertical, 11)
            .frame(minHeight: 44)
            .background(fieldBackground)
            .clipShape(RoundedRectangle(cornerRadius: .radius.medium, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: .radius.medium, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
            .accessibilityElement(children: .contain)

            if let message = viewModel.message {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(messageColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .onChange(of: text) { _, newValue in
            viewModel.updateText(newValue)
        }
        .onReceive(viewModel.$text) { newValue in
            guard text != newValue else {
                return
            }

            text = newValue
        }
        .onAppear {
            isFocused = viewModel.state == .focused
        }
    }

    @ViewBuilder
    private var field: some View {
        if viewModel.isSecure {
            SecureField(
                "",
                text: $text,
                prompt: Text(viewModel.placeholder).foregroundStyle(placeholderColor)
            )
            .textContentType(.password)
        } else {
            TextField(
                "",
                text: $text,
                prompt: Text(viewModel.placeholder).foregroundStyle(placeholderColor)
            )
        }
    }

    private var shouldShowClearButton: Bool {
        !text.isEmpty && (isFocused || viewModel.state == .focused) && !viewModel.isDisabled
    }
}

private extension TextFieldProperties.KeyboardType {
    var uiKeyboardType: UIKeyboardType {
        switch self {
        case .standard:
            return .default
        case .emailAddress:
            return .emailAddress
        case .numberPad:
            return .numberPad
        case .decimalPad:
            return .decimalPad
        case .phonePad:
            return .phonePad
        }
    }
}

extension TextFieldView {
    static func == (lhs: TextFieldView, rhs: TextFieldView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id &&
        lhs.text == rhs.text
    }
}

private extension TextFieldView {
    var isVibrant: Bool {
        viewModel.appearance == .vibrant
    }

    @ViewBuilder
    var fieldBackground: some View {
        if viewModel.isDisabled {
            Color.fills.quaternary
        } else {
            switch viewModel.appearance {
            case .standard:
                Color.fills.tertiary
            case .vibrant:
                ZStack {
                    Color.overlays.default
                    Color.fillsVibrant.secondary
                }
            }
        }
    }

    var labelColor: Color {
        isVibrant ? .labelsVibrant.secondary : .labels.secondary
    }

    var symbolColor: Color {
        isVibrant ? .labelsVibrant.secondary : .labels.secondary
    }

    var clearButtonColor: Color {
        isVibrant ? .labelsVibrant.quaternary : .labels.secondary
    }

    var valueColor: Color {
        isVibrant ? .labelsVibrant.secondary : .labels.primary
    }

    var placeholderColor: Color {
        if viewModel.isDisabled {
            return .labels.quaternary
        }

        return isVibrant ? .labelsVibrant.tertiary : .labels.tertiary
    }

    var caretColor: Color {
        isVibrant ? .labelsVibrant.overlay : .accents.blue
    }

    var messageColor: Color {
        if viewModel.showsError {
            return isVibrant ? .labelsVibrant.secondary : .accents.red
        }

        return isVibrant ? .labelsVibrant.secondary : .labels.secondary
    }

    var borderColor: Color {
        viewModel.showsError ? .accents.red : .clear
    }

    var borderWidth: CGFloat {
        guard viewModel.showsError else {
            return 0
        }

        return isVibrant ? 2 : 1.5
    }
}
