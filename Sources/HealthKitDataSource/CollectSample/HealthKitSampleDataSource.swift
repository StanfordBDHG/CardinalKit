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


final class HealthKitSampleDataSource<ComponentStandard: Standard, SampleType: HKSampleType>: HealthKitDataSource {
    let healthStore: HKHealthStore
    let standard: ComponentStandard
    
    let sampleType: SampleType
    let predicate: NSPredicate?
    let deliverySetting: HealthKitDeliverySetting
    let adapter: HealthKit<ComponentStandard>.HKSampleAdapter
    
    var didFinishLaunchingWithOptions = false
    var active = false
    var anchor: HKQueryAnchor?
    
    
    var anchorUserDefaultsKey: String {
        UserDefaults.Keys.healthKitAnchorPrefix.appending(sampleType.identifier)
    }
    
    
    required init( // swiftlint:disable:this function_default_parameter_at_end
        healthStore: HKHealthStore,
        standard: ComponentStandard,
        sampleType: SampleType,
        predicate: NSPredicate? = nil, // We order the parameters in a logical order and therefore don't put the predicate at the end here.
        deliverySetting: HealthKitDeliverySetting,
        adapter: HealthKit<ComponentStandard>.HKSampleAdapter
    ) {
        self.healthStore = healthStore
        self.standard = standard
        self.sampleType = sampleType
        self.predicate = predicate
        self.deliverySetting = deliverySetting
        self.adapter = adapter
        
        if deliverySetting.saveAnchor {
            guard let userDefaultsData = UserDefaults.standard.data(forKey: anchorUserDefaultsKey),
                  let newAnchor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: userDefaultsData) else {
                return
            }
            
            self.anchor = newAnchor
        }
    }
    
    
    func askedForAuthorization() {
        guard askedForAuthorization(for: sampleType) && !deliverySetting.isManual && !active && !didFinishLaunchingWithOptions else {
            return
        }
        
        Task {
            await triggerDataSourceCollection()
        }
    }
    
    func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
        defer {
            didFinishLaunchingWithOptions = true
        }
        
        guard askedForAuthorization(for: sampleType) else {
            return
        }
        
        switch deliverySetting {
        case let .anchorQuery(startSetting, _) where startSetting == .afterAuthorizationAndApplicationWillLaunch,
             let .background(startSetting, _) where startSetting == .afterAuthorizationAndApplicationWillLaunch:
            Task {
                await triggerDataSourceCollection()
            }
        default:
            break
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if deliverySetting.saveAnchor {
            guard let anchor,
                  let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true) else {
                return
            }
            
            UserDefaults.standard.set(data, forKey: UserDefaults.Keys.healthKitAnchorPrefix.appending(sampleType.identifier))
        }
    }
    
    func triggerDataSourceCollection() async {
        guard deliverySetting.isManual || !active else {
            return
        }
        
        switch deliverySetting {
        case .manual:
            await standard.registerDataSource(adapter.transform(anchoredSingleObjectQuery()))
        case .anchorQuery:
            active = true
            let healthKitSamples = await healthStore.anchoredContinousObjectQuery(for: sampleType, withPredicate: predicate)
            await standard.registerDataSource(adapter.transform(healthKitSamples))
        case .background:
            active = true
            let healthKitSamples = healthStore.startObservation(for: [sampleType], withPredicate: predicate)
                .flatMap { _ in
                    self.anchoredSingleObjectQuery()
                }
            await standard.registerDataSource(adapter.transform(healthKitSamples))
        }
    }
    
    
    private func anchoredSingleObjectQuery() -> AsyncThrowingStream<DataChange<HKSample, HKSample.ID>, Error> {
        AsyncThrowingStream { continuation in
            Task {
                let results = try await healthStore.anchoredSingleObjectQuery(
                    for: self.sampleType,
                    using: self.anchor,
                    withPredicate: predicate
                )
                self.anchor = results.anchor
                for result in results.elements {
                    continuation.yield(result)
                }
                continuation.finish()
            }
        }
    }
}
