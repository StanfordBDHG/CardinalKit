//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

extension Component {
    func inject(standard: ComponentStandard) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let standardPropertyWrapper = child.value as? _StandardPropertyWrapper<ComponentStandard> else {
                continue
            }
            standardPropertyWrapper.inject(standard: standard)
        }
    }
}


extension Component {
    /// Defines access to the shared ``Standard`` actor.
    ///
    /// A ``Component`` can define the injection of a ``Standard`` using the `@```Component/StandardActor`` property wrapper:
    /// ```
    /// class ExampleComponent: Component {
    ///     typealias ComponentStandard = ExampleStandard
    ///
    ///     @StandardActor var standard: ExampleStandard
    /// }
    /// ```
    ///
    /// You can access the wrapped value of the ``Standard`` after the ``Component`` is configured using ``Component/configure()-m7ic``,
    /// e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-26h4k`` function.
    public typealias StandardActor = _StandardPropertyWrapper<ComponentStandard>
}
