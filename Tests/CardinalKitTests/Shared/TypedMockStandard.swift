//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit


actor TypedMockStandard<T: Hashable & Identifiable & Sendable>: Standard where T == T.ID {
    typealias BaseType = CustomDataSourceType<T>
    typealias RemovalContext = BaseType.ID
    
    
    struct CustomDataSourceType<T: Hashable & Identifiable & Sendable>: Equatable, Identifiable {
        let id: T
    }
    
    
    let dataSourceExpecations: (DataChange<BaseType, RemovalContext>) async throws -> Void
    let finishedDataSourceSequence: (any TypedAsyncSequence<DataChange<BaseType, RemovalContext>>.Type) async throws -> Void
    
    
    init(
        dataSourceExpecations: @escaping (DataChange<BaseType, RemovalContext>) async throws -> Void
            = defaultDataSourceExpecations,
        finishedDataSourceSequence: @escaping (any TypedAsyncSequence<DataChange<BaseType, RemovalContext>>.Type) async throws -> Void
            = defaultFinishedDataSourceSequence
    ) {
        self.dataSourceExpecations = dataSourceExpecations
        self.finishedDataSourceSequence = finishedDataSourceSequence
    }
    
    
    static func defaultDataSourceExpecations(
        _ element: DataChange<BaseType, RemovalContext>
    ) {
        switch element {
        case let .addition(newElement):
            print("Added \(newElement)")
        case let .removal(deletedElementId):
            print("Removed element with \(deletedElementId)")
        }
    }
    
    static func defaultFinishedDataSourceSequence(
        _ sequenceType: any TypedAsyncSequence<DataChange<BaseType, RemovalContext>>.Type
    ) {
        print("Finished: \(String(describing: sequenceType))")
    }
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>) {
        Task {
            do {
                for try await element in asyncSequence {
                    try await dataSourceExpecations(element)
                }
                try await finishedDataSourceSequence(type(of: asyncSequence))
            } catch {
                XCTFail("Failed data source of type \(String(describing: type(of: asyncSequence))) with \(error).")
            }
        }
    }
    
    func fulfill(expectation: XCTestExpectation) {
        expectation.fulfill()
    }
}
