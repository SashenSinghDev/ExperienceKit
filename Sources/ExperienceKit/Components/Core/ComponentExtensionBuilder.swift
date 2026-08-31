import Foundation

public extension Component {
    static func buttonComponent(properties: ButtonProperties) -> Component {
        return Component(contentType: "button",
                         properties: properties,
                         id: UUID())
    }

    static func containerComponent(properties: ContainerProperties) -> Component {
        return Component(contentType: "container",
                         properties: properties,
                         id: UUID())
    }

    static func descriptionComponent(properties: DescriptionProperties) -> Component {
        return Component(contentType: "description",
                         properties: properties,
                         id: UUID())
    }

    static func exampleComponent(properties: ExampleProperties) -> Component {
        return Component(contentType: "example",
                         properties: properties,
                         id: UUID())
    }

    static func fullscreenComponent(properties: FullScreenProperties) -> Component {
        return Component(contentType: "fullscreen",
                         properties: properties,
                         id: UUID())
    }

    static func genericlistitemComponent(properties: GenericListItemProperties) -> Component {
        return Component(contentType: "genericlistitem",
                         properties: properties,
                         id: UUID())
    }

    static func sectiontitleComponent(properties: SectionTitleProperties) -> Component {
        return Component(contentType: "sectiontitle",
                         properties: properties,
                         id: UUID())
    }

    static func separatorComponent(properties: SeparatorProperties) -> Component {
        return Component(contentType: "separator",
                         properties: properties,
                         id: UUID())
    }

    static func spacerComponent(properties: SpacerProperties) -> Component {
        return Component(contentType: "spacer",
                         properties: properties,
                         id: UUID())
    }

    static func welcomeComponent(properties: WelcomeProperties) -> Component {
        return Component(contentType: "welcome",
                         properties: properties,
                         id: UUID())
    }

}
