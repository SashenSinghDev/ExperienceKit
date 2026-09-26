//
//  TextFieldComponentInteractor.swift
//  Example
//
//  Created by Codex on 26/09/2026.
//

import ExperienceKit
import SwiftUI

final class TextFieldComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "Sign in")),
            textField(
                state: .filled,
                keyboardType: .emailAddress,
                label: "Email",
                placeholder: "name@example.com",
                value: "jordan@example.com",
                leadingSystemImage: "envelope",
                helperText: nil
            ),
            textField(
                state: .empty,
                isSecure: true,
                label: "Password",
                placeholder: "Required",
                value: "",
                leadingSystemImage: "lock",
                helperText: nil
            ),
            .spacerComponent(properties: .init(size: .large)),
            .sectiontitleComponent(properties: .init(title: "Search")),
            textField(
                state: .focused,
                label: nil,
                placeholder: "Search by station, hotel, activity",
                value: "Coffee near me",
                leadingSystemImage: "magnifyingglass",
                helperText: nil,
                accessibilityLabel: "Search"
            ),
            .spacerComponent(properties: .init(size: .large)),
            .sectiontitleComponent(properties: .init(title: "Weight")),
            textField(
                state: .filled,
                keyboardType: .decimalPad,
                label: "Weight",
                placeholder: "Weight",
                value: "93",
                leadingSystemImage: nil,
                unit: "kg",
                helperText: "Enter a weight between 20 and 300 kg."
            ),
            .spacerComponent(properties: .init(size: .large)),
            .sectiontitleComponent(properties: .init(title: "Validation")),
            textField(
                state: .error,
                label: "Username",
                placeholder: "Username",
                value: "@jordan",
                leadingSystemImage: "person",
                helperText: nil,
                errorMessage: "This username is already taken.",
                accessibilityLabel: "Username"
            ),
            .spacerComponent(properties: .init(size: .large)),
            .sectiontitleComponent(properties: .init(title: "Helper text")),
            textField(
                state: .filled,
                keyboardType: .phonePad,
                label: "Phone number",
                placeholder: "+44 7700 900000",
                value: "+44 7700 900000",
                leadingSystemImage: "phone",
                helperText: "Only used for delivery updates."
            ),
            textField(
                state: .disabled,
                label: "Account ID",
                placeholder: "Assigned after sign-up",
                value: "",
                leadingSystemImage: nil,
                helperText: nil
            )
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    private func textField(state: TextFieldProperties.State,
                           isSecure: Bool = false,
                           keyboardType: TextFieldProperties.KeyboardType = .standard,
                           label: String?,
                           placeholder: String = "name@example.com",
                           value: String = "jordan@example.com",
                           leadingSystemImage: String? = "envelope",
                           showsClearButton: Bool = true,
                           unit: String? = nil,
                           helperText: String? = "We'll send a confirmation link to this address.",
                           errorMessage: String? = "Enter a valid email address.",
                           accessibilityLabel: String? = nil) -> Component {
        .containerComponent(properties: .init(
            component: .textfieldComponent(properties: .init(
                state: state,
                isSecure: isSecure,
                keyboardType: keyboardType,
                label: label,
                placeholder: placeholder,
                value: isSecure ? "password" : value,
                leadingSystemImage: leadingSystemImage,
                showsClearButton: showsClearButton,
                unit: unit,
                helperText: helperText,
                errorMessage: errorMessage,
                accessibilityLabel: accessibilityLabel ?? label,
                selectionKey: "\(state)-\(isSecure)-\(placeholder)-\(label ?? "unlabelled")"
            )),
            horizontalSpacing: .medium)
        )
    }
}
