//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


/// Collects a specificied `HKSampleType`  in the ``HealthKit`` component.
public struct CollectSample<SampleType: HKSampleType>: HealthKitDataSourceDescription {
    let sampleType: SampleType
    let deliverySetting: HealthKitDeliverySetting
    
    
    public var sampleTypes: Set<HKSampleType> {
        [sampleType]
    }
    
    
    /// - Parameters:
    ///   - sampleType: The `HKSampleType` that should be collected
    ///   - deliverySetting: The ``HealthKitDeliverySetting`` that should be used to collect the sample type. `.manual` is the default argument used.
    public init(_ sampleType: SampleType, deliverySetting: HealthKitDeliverySetting = .manual()) {
        self.sampleType = sampleType
        self.deliverySetting = deliverySetting
    }
    
    
    public func dataSource<S: Standard>(healthStore: HKHealthStore, standard: S, adapter: HealthKit<S>.HKSampleAdapter) -> HealthKitDataSource {
        HealthKitSampleDataSource<S, SampleType>(
            healthStore: healthStore,
            standard: standard,
            sampleType: sampleType,
            deliverySetting: deliverySetting,
            adapter: adapter
        )
    }
}
