//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import SwiftUI
import XCTest
import XCTRuntimeAssertions


final class DataStorageProviderTests: XCTestCase {
    private enum MockUpload {
        case post(String)
        case delete(String)
        
        
        func assertPost(is value: String) {
            guard case let .post(test) = self else {
                XCTFail("Expected a .post and got: \(self)")
                return
            }
            XCTAssertEqual(test, value)
        }
        
        func assertDelete(is value: String) {
            guard case let .delete(test) = self else {
                XCTFail("Expected a .delete and got: \(self)")
                return
            }
            XCTAssertEqual(test, value)
        }
    }
    
    
    private actor DataStorageExample<
        ComponentStandard: Standard
    >: DataStorageProvider where ComponentStandard.BaseType: Encodable, ComponentStandard.BaseType.ID == String {
        let mockUpload: (MockUpload) -> Void
        
        
        init(mockUpload: @escaping (MockUpload) -> Void) {
            self.mockUpload = mockUpload
        }
        
        
        func process(_ element: DataChange<ComponentStandard.BaseType, ComponentStandard.RemovalContext>) async throws {
            switch element {
            case let .addition(element):
                let data = try JSONEncoder().encode(element)
                let string = String(decoding: data, as: UTF8.self)
                mockUpload(.post(string))
            case let .removal(removalContext):
                mockUpload(.delete(removalContext.id))
            }
        }
    }
    
    
    private actor DataStorageProviderStandard: Standard {
        typealias BaseType = CustomDataSourceType<String>
        typealias RemovalContext = BaseType
        
        
        struct CustomDataSourceType<T: Encodable & Hashable>: Encodable, Equatable, Identifiable {
            let id: T
        }
        
        
        @DataStorageProviders
        var dataSources: [any DataStorageProvider<DataStorageProviderStandard>]
        
        
        func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>) {
            Task {
                do {
                    for try await element in asyncSequence {
                        switch element {
                        case let .addition(element):
                            for dataSource in dataSources {
                                try await dataSource.process(.addition(element))
                            }
                        case let .removal(id):
                            for dataSource in dataSources {
                                try await dataSource.process(.removal(id))
                            }
                        }
                    }
                } catch {
                    XCTFail("Failed data source of type \(String(describing: type(of: asyncSequence))) with \(error).")
                }
            }
        }
    }
    
    private class DataStorageProviderApplicationDelegate: CardinalKitAppDelegate {
        let mockUpload: (MockUpload) -> Void
        
        
        override var configuration: Configuration {
            Configuration(standard: DataStorageProviderStandard()) {
                DataStorageExample(mockUpload: mockUpload)
            }
        }
        
        
        init(mockUpload: @escaping (MockUpload) -> Void) {
            self.mockUpload = mockUpload
        }
    }
    
    
    @MainActor
    func testDataStorageProviderTests() async throws {
        let expectation = expectation(description: "Timeout Expection")
        expectation.isInverted = true
        
        var count = 0
        let delegate = DataStorageProviderApplicationDelegate { mockUpload in
            switch count {
            case 0:
                mockUpload.assertPost(is: #"{"id":"42"}"#)
            case 1:
                mockUpload.assertPost(is: #"{"id":"43"}"#)
            case 2:
                mockUpload.assertPost(is: #"{"id":"44"}"#)
            case 3:
                mockUpload.assertDelete(is: "44")
            default:
                XCTFail("Too many calls to the mock upload function.")
            }
            count += 1
        }
        
        let cardinalKit = try XCTUnwrap(delegate.cardinalKit as? CardinalKit<DataStorageProviderStandard>)
        await cardinalKit.standard.registerDataSource(
            asyncStream: AsyncStream { continuation in
                continuation.yield(DataChange.addition(DataStorageProviderStandard.BaseType(id: "42")))
                continuation.yield(DataChange.addition(DataStorageProviderStandard.BaseType(id: "43")))
                continuation.yield(DataChange.addition(DataStorageProviderStandard.BaseType(id: "44")))
                continuation.yield(DataChange.removal(DataStorageProviderStandard.RemovalContext(id: "44")))
            }
        )
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(count, 4)
    }
    
    
    func testInjectionPreconditionDependencyPropertyWrapper() throws {
        try XCTRuntimePrecondition {
            _ = _DataStorageProvidersPropertyWrapper<MockStandard>().wrappedValue
        }
    }
}
