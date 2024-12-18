//
//  DefaultExperiencePresenter.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation
import SwiftUI

public final class ExperiencePresenter: ObservableObject {
    
    public enum State {
         case idle
         case loading
         case failed(Error)
         case loaded([AnyComponentViewModel])
     }
    
    @Published public var state: State = .idle

    private let viewModelProvider: ViewModelProvider
    private let experienceInteractor: ExperienceInteractor

    public init(viewModelProvider: ViewModelProvider,
                experienceInteractor: ExperienceInteractor) {
        self.viewModelProvider = viewModelProvider
        self.experienceInteractor = experienceInteractor
    }

    public func load() {
        self.experienceInteractor.load { [weak self] components in

            guard let self else { return }

            let viewModels: [AnyComponentViewModel] = components.compactMap {
                return self.viewModelProvider.viewModel(for: $0)
            }

            self.state = .loaded(viewModels)
        }
    }
}
