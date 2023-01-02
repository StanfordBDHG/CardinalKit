//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``Component`` defines a software subsystem that can be configured as part of the ``CardinalKitAppDelegate/configuration``.
public protocol Component<ComponentStandard>: AnyObject, TypedCollectionKey {
    /// A ``Component/ComponentStandard`` defines what ``Standard`` the component supports.
    associatedtype ComponentStandard: Standard
    
    /// The ``Component/configure()-m7ic`` method is called on the initialization of the CardinalKit instance to perform a lightweight configuration of the component.
    ///
    /// It is advised that longer setup tasks are done in an asynchronous task and started during the call of the configure method.
    func configure()
}


extension Component {
    // A documentation for this methodd exists in the `Component` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func configure() {}
}
