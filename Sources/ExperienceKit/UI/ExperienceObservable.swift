//
//  File.swift
//  
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation

final public class ExperienceObservable: ObservableObject {

    private let presenter: ExperiencePresenter
    @Published var anyViewModel: Experience.AnyViewModel = .defaultState

    public init(presenter: ExperiencePresenter) {
        self.presenter = presenter
    }

}

extension ExperienceObservable: ExperiencePresenter {

    public func performAction(_ action: Experience.Action) {
        presenter.performAction(action)
    }

}

extension ExperienceObservable: ExperienceScene {

    public func performUpdate(_ update: Experience.Update) {

        switch update {
        case .setAnyViewModel(let anyViewModel):
            self.anyViewModel = anyViewModel
        }
    }

}
