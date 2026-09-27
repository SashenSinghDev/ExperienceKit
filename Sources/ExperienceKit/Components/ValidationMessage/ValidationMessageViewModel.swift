import Combine
import Foundation

public final class ValidationMessageViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasExperienceSelectionStateStore & HasExperienceSelectionChanges

    public let id: UUID
    /// The text to show, or `nil` once every field has a value.
    @Published private(set) var message: String?

    private let template: String
    private let conjunction: String
    private var remainingFields: [ValidationMessageProperties.Field]
    private let experienceSelectionStateStore: ExperienceSelectionStateStore?
    private var cancellables = Set<AnyCancellable>()

    public init(properties: ValidationMessageProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.template = properties.template
        self.conjunction = properties.conjunction
        let store = dependency.experienceSelectionStateStore
        let remainingFields = properties.fields.filter { !Self.hasValue(for: $0, in: store) }
        self.experienceSelectionStateStore = store
        self.remainingFields = remainingFields
        self.message = Self.message(for: remainingFields,
                                    template: properties.template,
                                    conjunction: properties.conjunction)

        dependency.experienceSelectionChanges
            .sink { [weak self] key in
                self?.selectionDidChange(for: key)
            }
            .store(in: &cancellables)
    }

    /// Fields only ever leave the list. Emptying a field again does not bring it
    /// back; that waits for the next submit, matching the text field's error border.
    private func selectionDidChange(for key: String) {
        guard let field = remainingFields.first(where: { $0.selectionKey == key }),
              Self.hasValue(for: field, in: experienceSelectionStateStore) else {
            return
        }

        remainingFields.removeAll { $0 == field }
        message = Self.message(for: remainingFields, template: template, conjunction: conjunction)
    }

    private static func hasValue(for field: ValidationMessageProperties.Field,
                                 in store: ExperienceSelectionStateStore?) -> Bool {
        let value = store?.selectedValues(for: field.selectionKey).first ?? ""
        return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// "height" / "height and age" / "weight, height and age"
    static func message(for fields: [ValidationMessageProperties.Field],
                        template: String,
                        conjunction: String) -> String? {
        let names = fields.map(\.name)
        guard let lastName = names.last else {
            return nil
        }

        let list = names.count == 1
            ? lastName
            : names.dropLast().joined(separator: ", ") + " \(conjunction) " + lastName

        return template.replacingOccurrences(of: "{fields}", with: list)
    }
}
