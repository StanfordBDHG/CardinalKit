//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


/// A common protocol that data sources collecting HealthKit data for the ``HealthKit`` module conform to.
public protocol HealthKitDataSourceDescription {
    /// The sample types that should be collected.
    var sampleTypes: Set<HKSampleType> { get }
    
    
    /// The ``HealthKitDataSourceDescription/dataSource(healthStore:standard:adapter:)`` method creates a ``HealthKitDataSource`` when the HealthKit component is instantiated.
    /// - Parameters:
    ///   - healthStore: The `HKHealthStore` instance that the queries should be performed on.
    ///   - standard: The `Standard` instance that is used in the software system.
    ///   - adapter: An adapter that can adapt HealthKit data to the corresponding data standard.
    func dataSource<S: Standard>(healthStore: HKHealthStore, standard: S, adapter: HealthKit<S>.HKSampleAdapter) -> HealthKitDataSource
}
