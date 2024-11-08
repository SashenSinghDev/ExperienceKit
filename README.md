# ExperienceKit

```mermaid

flowchart TD

subgraph Components
    ExampleProperties
    ExampleViewModel
    ExampleComponentView
    ExampleComponentRegister
    
    %% Relationships
    ExampleViewModel-->ExampleProperties
    ExampleProperties-.->Properties{{Properties}}
    ExampleViewModel-.->ComponentViewModel{{ComponentViewModel}}
    ExampleComponentView-.->ComponentView{{ComponentView}}
    ExampleComponentRegister-.->ComponentRegister{{ComponentRegister}}
    ExampleComponentRegister-->ExampleComponentView
    ExampleComponentRegister-->ExampleViewModel
end

subgraph UI
    ExperienceView
    ViewProvider
    ViewModelProvider
    ExperiencePresenter

    %% Relationships
    ViewModelProvider-->ComponentRegister{{ComponentRegister}}
    ViewProvider-->ComponentRegister{{ComponentRegister}}
    ExperienceView-->ViewProvider
    ExperiencePresenter-->ViewModelProvider
    ExperienceView-->ExperiencePresenter
end

subgraph Service
    ExperienceService{{ExperienceService}}
end

subgraph BusinessLogic
    ExperienceInteractor{{ExperienceInteractor}}
    
    %% Relationships
    ExperienceInteractor{{ExperienceInteractor}}-->ExperienceService{{ExperienceService}}
end

ExperiencePresenter-->ExperienceInteractor



 






```
