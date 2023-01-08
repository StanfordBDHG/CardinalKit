//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FirebaseDataStorage
import Foundation


actor TestAppStandard: Standard, ObservableObjectProvider, ObservableObject {
    typealias BaseType = TestAppStandardBaseType
    typealias RemovalContext = TestAppStandardRemovalContext
    
    
    struct TestAppStandardBaseType: Identifiable, Sendable, FirestoreElement {
        let id: String
        let content: Int
        let collectionPath: String
        
        
        init(id: String, content: Int = 42, collectionPath: String = "TestAppStandardDataChange") {
            self.collectionPath = collectionPath
            self.id = id
            self.content = content
        }
    }
    
    struct TestAppStandardRemovalContext: Identifiable, Sendable, FirestoreRemovalContext {
        let id: TestAppStandardBaseType.ID
        let collectionPath: String
        
        
        init(id: TestAppStandardBaseType.ID, collectionPath: String = "TestAppStandardDataChange") {
            self.collectionPath = collectionPath
            self.id = id
        }
    }
    
    
    var dataChanges: [DataChange<BaseType, RemovalContext>] = [] {
        willSet {
            Task { @MainActor in
                self.objectWillChange.send()
            }
        }
    }
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>) {
        Task {
            do {
                for try await element in asyncSequence {
                    switch element {
                    case let .addition(newElement):
                        print("Added \(newElement)")
                    case let .removal(deletedElementId):
                        print("Removed element with \(deletedElementId)")
                    }
                    dataChanges.append(element)
                }
            } catch {
                fatalError(
                    """
                    Unexpected error in \(error).
                    Do not use `fatalError` in production code. We only use this to validate the tests.
                    """
                )
            }
        }
    }
}
