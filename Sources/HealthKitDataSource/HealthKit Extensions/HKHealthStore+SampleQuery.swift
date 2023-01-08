//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


extension HKHealthStore {
    func sampleQuery(
        for sampleType: HKSampleType,
        withPredicate predicate: NSPredicate? = nil
    ) async throws -> [HKSample] {
        try await self.requestAuthorization(toShare: [], read: [sampleType])
        
        // Create the descriptor.
        let sampleQueryDescriptor = HKSampleQueryDescriptor(
            predicates: [
                .sample(type: sampleType, predicate: predicate)
            ],
            sortDescriptors: [
                SortDescriptor(\.endDate, order: .reverse)
            ]
        )
        
        return try await sampleQueryDescriptor.result(for: self)
    }
    
    
    func sampleQueryStream(
        for sampleType: HKSampleType,
        withPredicate predicate: NSPredicate? = nil
    ) -> AsyncThrowingStream<DataChange<HKSample, HKSample.ID>, Error> {
        AsyncThrowingStream { continuation in
            Task {
                for sample in try await sampleQuery(for: sampleType, withPredicate: predicate) {
                    continuation.yield(.addition(sample))
                }
                continuation.finish()
            }
        }
    }
}
