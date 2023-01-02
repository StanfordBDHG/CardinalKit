//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit
import SwiftUI


/// The ``HealthKit`` module enables the collection of HealthKit data and transforms it to the component's standard's base type using a `DataSourceRegistryAdapter` (``HealthKit/Adapter``)
///
/// Use the ``HealthKit/init(_:adapter:)`` initializer to define different ``HealthKitDataSourceDescription``s to define the data collection.
/// You can, e.g., use ``CollectSample`` to collect a wide variaty of `HKSampleTypes`:
/// ```
/// class ExampleAppDelegate: CardinalKitAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: ExampleStandard()) {
///             if HKHealthStore.isHealthDataAvailable() {
///                 HealthKit {
///                     CollectSample(
///                         HKQuantityType.electrocardiogramType(),
///                         deliverySetting: .background(.manual)
///                     )
///                     CollectSample(
///                         HKQuantityType(.stepCount),
///                         deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
///                     )
///                     CollectSample(
///                         HKQuantityType(.pushCount),
///                         deliverySetting: .anchorQuery(.manual)
///                     )
///                     CollectSample(
///                         HKQuantityType(.activeEnergyBurned),
///                         deliverySetting: .anchorQuery(.afterAuthorizationAndApplicationWillLaunch)
///                     )
///                     CollectSample(
///                         HKQuantityType(.restingHeartRate),
///                         deliverySetting: .manual()
///                     )
///                 } adapter: {
///                     TestAppHealthKitAdapter()
///                 }
///             }
///         }
///     }
/// }
/// ```
public final class HealthKit<ComponentStandard: Standard>: Module {
    /// The ``HealthKit/Adapter`` type defines the mapping of `HKSample`s to the component's standard's base type.
    public typealias Adapter = any DataSourceRegistryAdapter<HKSample, ComponentStandard.BaseType>
    
    
    @StandardActor var standard: ComponentStandard
    
    let healthStore: HKHealthStore
    let healthKitDataSourceDescriptions: [HealthKitDataSourceDescription]
    let adapter: Adapter
    lazy var healthKitComponents: [any HealthKitDataSource] = {
        healthKitDataSourceDescriptions
            .map { $0.dataSource(healthStore: healthStore, standard: standard, adapter: adapter) }
    }()
    
    
    /// Creates a new instance of the ``HealthKit`` module.
    /// - Parameters:
    ///   - healthKitDataSourceDescriptions: The ``HealthKitDataSourceDescription``s define what data is collected by the ``HealthKit`` module. You can, e.g., use ``CollectSample`` to collect a wide variaty of `HKSampleTypes`.
    ///   - adapter: The ``HealthKit/Adapter`` type defines the mapping of `HKSample`s to the component's standard's base type.
    public init(
        @HealthKitDataSourceDescriptionBuilder _ healthKitDataSourceDescriptions: () -> ([HealthKitDataSourceDescription]),
        @DataSourceRegistryAdapterBuilder<ComponentStandard> adapter: () -> (Adapter)
    ) {
        precondition(
            HKHealthStore.isHealthDataAvailable(),
            """
            HealthKit is not available on this device.
            Check if HealthKit is available e.g., using `HKHealthStore.isHealthDataAvailable()`:
            
            if HKHealthStore.isHealthDataAvailable() {
                HealthKitHealthStore()
            }
            """
        )
        
        let healthStore = HKHealthStore()
        let adapter = adapter()
        let healthKitDataSourceDescriptions = healthKitDataSourceDescriptions()
        
        self.adapter = adapter
        self.healthKitDataSourceDescriptions = healthKitDataSourceDescriptions
        self.healthStore = healthStore
    }
    
    
    /// Displays the user interface to ask for authorization for all HealthKit data defined by the ``HealthKitDataSourceDescription``s.
    ///
    /// Call this function when you want to start HealthKit data collection.
    public func askForAuthorization() async throws {
        var sampleTypes: Set<HKSampleType> = []
        
        for healthKitDataSourceDescription in healthKitDataSourceDescriptions {
            sampleTypes = sampleTypes.union(healthKitDataSourceDescription.sampleTypes)
        }
        
        let requestedSampleTypes = Set(UserDefaults.standard.stringArray(forKey: UserDefaults.Keys.healthKitRequestedSampleTypes) ?? [])
        guard !Set(sampleTypes.map { $0.identifier }).isSubset(of: requestedSampleTypes) else {
            return
        }
        
        try await healthStore.requestAuthorization(toShare: [], read: sampleTypes)
        
        UserDefaults.standard.set(sampleTypes.map { $0.identifier }, forKey: UserDefaults.Keys.healthKitRequestedSampleTypes)
        
        for healthKitComponent in healthKitComponents {
            healthKitComponent.askedForAuthorization()
        }
    }
    
    
    /// Triggers any ``HealthKitDeliverySetting/manual(safeAnchor:)`` collections and starts the collection for all ``HealthKitDeliveryStartSetting/manual`` HealthKit data collections.
    public func triggerDataSourceCollection() async {
        await withTaskGroup(of: Void.self) { group in
            for healthKitComponent in healthKitComponents {
                group.addTask {
                    await healthKitComponent.triggerDataSourceCollection()
                }
            }
            await group.waitForAll()
        }
    }
}
