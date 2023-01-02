//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SwiftUI


/// Open-source framework for rapid development of modern, interoperable digital health applications.
///
/// Set up the CardinalKit framework in your `App` instance of your SwiftUI applicaton using the ``CardinalKitAppDelegate`` and the `@UIApplicationDelegateAdaptor` property wrapper.
/// Use the `View.cardinalKit(_: CardinalKitAppDelegate)` view modifier to apply your CardinalKit configuration to the main view in your SwiftUI `Scene`:
/// ```
/// import CardinalKit
/// import SwiftUI
///
///
/// @main
/// struct ExampleApp: App {
///     @UIApplicationDelegateAdaptor(CardinalKitAppDelegate.self) var appDelegate
///
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .cardinalKit(appDelegate)
///         }
///     }
/// }
/// ```
public actor CardinalKit<S: Standard>: AnyCardinalKit, ObservableObject {
    /// A typesafe typedCollection of different elements of an ``CardinalKit/CardinalKit`` instance.
    public let typedCollection: TypedCollection
    /// Logger used to log events in the ``CardinalKit/CardinalKit`` instance.
    public let logger: Logger
    /// The ``Standard`` used in the ``CardinalKit/CardinalKit`` instance.
    public let standard: S
    
    
    init(
        standard: S,
        components: [any Component<S>],
        _ logger: Logger = Logger(subsystem: "edu.stanford.cardinalkit", category: "cardinalkit")
    ) {
        self.logger = logger
        self.typedCollection = TypedCollection(logger: logger)
        self.standard = standard
        
        var componentsAndStandard = components
        componentsAndStandard.append(standard)
        
        let sortedComponents = DependencyManager(componentsAndStandard).sortedComponents
        
        for component in sortedComponents {
            component.inject(standard: standard)
            component.configure()
            component.saveInTypedCollection(cardinalKit: self)
        }
        
        standard.inject(dataStorageProviders: dataStorageProviders)
    }
}
