//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Standard {
    nonisolated func inject(dataStorageProviders: [any DataStorageProvider<Self>]) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let standardPropertyWrapper = child.value as? DataStorageProviders else {
                continue
            }
            standardPropertyWrapper.inject(dataStorageProviders: dataStorageProviders)
        }
    }
}


extension Standard {
    /// Defines access to the data storage providers in the ``Standard`` actor.
    ///
    /// A ``Standard`` can gain access to all data storage providers using the `@```Standard/DataStorageProviders`` property wrapper:
    /// ```
    /// actor ExampleStandard: Standard {
    ///     @DataStorageProviders
    ///     var dataSources: [any DataStorageProvider<ExampleStandard>]
    ///
    ///     // ...
    /// }
    /// ```
    /// 
    /// You can access the wrapped value of the `@` ``Standard/DataStorageProviders`` after the ``Standard`` is configured using ``Component/configure()-5lup3``,
    /// e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-26h4k`` function.
    public typealias DataStorageProviders = _DataStorageProvidersPropertyWrapper<Self>
}
