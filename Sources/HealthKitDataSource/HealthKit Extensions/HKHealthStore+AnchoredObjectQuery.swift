//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


extension HKSample: Identifiable {
    public var id: UUID {
        uuid
    }
}


extension HKHealthStore {
    actor AnchoredObjectQueryContext {
        var anchor: HKQueryAnchor?
        var queryTask: Task<Void, Error>?
    }
    
    
    func anchoredContinousObjectQuery(
        for sampleType: HKSampleType,
        withPredicate predicate: NSPredicate? = nil
    ) async -> any TypedAsyncSequence<DataChange<HKSample, HKSample.ID>> {
        AsyncThrowingStream { continuation in
            Task {
                try await self.requestAuthorization(toShare: [], read: [sampleType])
                
                var anchor: HKQueryAnchor?
                let anchorDescriptor = anchorDescriptor(sampleType: sampleType, predicate: predicate, anchor: anchor)
                
                let updateQueue = anchorDescriptor.results(for: self)
                
                do {
                    for try await results in updateQueue {
                        if Task.isCancelled {
                            continuation.finish()
                            return
                        }
                        
                        for deletedObject in results.deletedObjects {
                            continuation.yield(.removal(deletedObject.uuid))
                        }
                        
                        for addedSample in results.addedSamples {
                            continuation.yield(.addition(addedSample))
                        }
                        anchor = results.newAnchor
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    
    func anchoredSingleObjectQuery(
        for sampleType: HKSampleType,
        using anchor: HKQueryAnchor? = nil,
        withPredicate predicate: NSPredicate? = nil
    ) async throws -> (elements: [DataChange<HKSample, HKSample.ID>], anchor: HKQueryAnchor) {
        try await self.requestAuthorization(toShare: [], read: [sampleType])
        
        let anchorDescriptor = anchorDescriptor(sampleType: sampleType, predicate: predicate, anchor: anchor)
        
        let result = try await anchorDescriptor.result(for: self)
        
        var elements: [DataChange<HKSample, HKSample.ID>] = []
        elements.reserveCapacity(result.deletedObjects.count + result.addedSamples.count)
        
        for deletedObject in result.deletedObjects {
            elements.append(.removal(deletedObject.uuid))
        }
        
        for addedSample in result.addedSamples {
            elements.append(.addition(addedSample))
        }
        
        return (elements, result.newAnchor)
    }
    
    
    private func anchorDescriptor(
        sampleType: HKSampleType,
        predicate: NSPredicate?,
        anchor: HKQueryAnchor?
    ) -> HKAnchoredObjectQueryDescriptor<HKSample> {
        HKAnchoredObjectQueryDescriptor(
            predicates: [
                .sample(type: sampleType, predicate: predicate)
            ],
            anchor: anchor
        )
    }
}
