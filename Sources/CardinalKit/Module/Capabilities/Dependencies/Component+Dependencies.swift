//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Component {
    /// Defines a dependency to another ``Component``.
    ///
    /// A ``Component`` can define the dependencies using the `@```Component/Dependency`` property wrapper:
    /// ```
    /// class ExampleComponent<ComponentStandard: Standard>: Component {
    ///     @Dependency var exampleComponentDependency = ExampleComponentDependency()
    /// }
    /// ```
    ///
    /// Some components do not need a default value assigned to the property if they provide a default configuration and conform to ``DefaultInitializable``.
    /// ```
    /// class ExampleComponent<ComponentStandard: Standard>: Component {
    ///     @Dependency var exampleComponentDependency: ExampleComponentDependency
    /// }
    /// ```
    ///
    /// You can access the wrapped value of the ``Dependency`` after the ``Component`` is configured using ``Component/configure()-5lup3``,
    /// e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-26h4k`` function.
    public typealias Dependency<C: Component> = _DependencyPropertyWrapper<C, ComponentStandard> where C.ComponentStandard == ComponentStandard
    
    
    /// Defines dynamic dependencies to other ``Component``s.
    /// In contrast to the `@Dependency` property wrapper, the `@DynamicDependencies` enables the generation of the property wrapper in the initializer and generating an
    /// arbitrary amount of dependencies that are resolved in the CardinalKit initialization.
    ///
    /// A ``Component`` can define dynamic dependencies using the `@```Component/DynamicDependencies`` property wrapper and can, e.g., initialize its value in the initializer.
    /// ```
    /// class ExampleComponent<ComponentStandard: Standard>: Component {
    ///     @DynamicDependencies var dynamicDependencies: [any Component<ComponentStandard>]
    ///
    ///
    ///     init() {
    ///         self._healthKitComponents = DynamicDependencies(
    ///             componentProperties: [
    ///                 Dependency(wrappedValue: /* ... */),
    ///                 Dependency(wrappedValue: /* ... */)
    ///             ]
    ///         )
    ///     }
    /// }
    /// ```
    ///
    /// You can access the wrapped value of the ``DynamicDependencies`` after the ``Component`` is configured using ``Component/configure()-5lup3``,
    /// e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-26h4k`` function.
    public typealias DynamicDependencies = _DynamicDependenciesPropertyWrapper<ComponentStandard>
}
