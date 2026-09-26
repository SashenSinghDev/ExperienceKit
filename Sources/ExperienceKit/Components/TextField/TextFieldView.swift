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
                        .foregroundStyle(unitColor)
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
            .padding(.horizontal, Self.fieldHorizontalPadding)
            .padding(.vertical, Self.fieldVerticalPadding)
            .frame(minHeight: Self.fieldMinHeight)
            .background(fieldBackground)
            .clipShape(RoundedRectangle(cornerRadius: .radius.full, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: .radius.full, style: .continuous)
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
        viewModel.showsClearButton &&
        !text.isEmpty &&
        (isFocused || viewModel.state == .focused) &&
        !viewModel.isDisabled
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
    /// Figma: Field horizontal padding — 20pt (not bound to a spacing token in Figma).
    static let fieldHorizontalPadding: CGFloat = 20

    /// Centres Type/Body (22pt line height) in the 52pt Figma field while letting it grow with Dynamic Type.
    static let fieldVerticalPadding: CGFloat = 15

    /// Figma: Field min height — 44pt.
    static let fieldMinHeight: CGFloat = 44

    /// Figma: Error border — 1.5pt color/accents/red.
    static let errorBorderWidth: CGFloat = 1.5

    var fieldBackground: Color {
        .backgroundsGrouped.secondary
    }

    var labelColor: Color {
        viewModel.isDisabled ? .labels.tertiary : .labels.secondary
    }

    var symbolColor: Color {
        viewModel.isDisabled ? .labels.tertiary : .labels.secondary
    }

    var unitColor: Color {
        viewModel.isDisabled ? .labels.tertiary : .labels.secondary
    }

    var clearButtonColor: Color {
        .labels.tertiary
    }

    var valueColor: Color {
        .labels.primary
    }

    var placeholderColor: Color {
        viewModel.isDisabled ? .labels.quaternary : .labels.tertiary
    }

    var caretColor: Color {
        .accents.blue
    }

    var messageColor: Color {
        if viewModel.showsError {
            return .accents.red
        }

        return viewModel.isDisabled ? .labels.tertiary : .labels.secondary
    }

    var borderColor: Color {
        viewModel.showsError ? .accents.red : .clear
    }

    var borderWidth: CGFloat {
        viewModel.showsError ? Self.errorBorderWidth : 0
    }
}
