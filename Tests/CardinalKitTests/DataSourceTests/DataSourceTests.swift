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


final class DataSourceTests: XCTestCase {
    private final class DataSourceTestComponentInjector<T: Hashable & Identifiable & Sendable>: Component where T == T.ID {
        typealias ComponentStandard = TypedMockStandard<T>
        
        
        @DynamicDependencies private var dynamicDependencies: [any Component<ComponentStandard>]
        
        
        init(_ dynamicDependencies: DynamicDependencies) {
            self._dynamicDependencies = dynamicDependencies
        }
    }
    
    final class DataSourceTestComponent<
        T: Identifiable,
        MockStandardType: Identifiable
    >: Component, LifecycleHandler where T.ID: Identifiable, T.ID == T.ID.ID, MockStandardType == MockStandardType.ID {
        typealias ComponentStandard = TypedMockStandard<MockStandardType>
        
        
        @StandardActor var standard: TypedMockStandard<MockStandardType>
        var injectedData: [DataChange<T, T.ID>]
        let adapter: any Adapter<T, T.ID, TypedMockStandard<MockStandardType>.BaseType, TypedMockStandard<MockStandardType>.RemovalContext>
        
        
        init(
            injectedData: [DataChange<T, T.ID>],
            @AdapterBuilder<TypedMockStandard<MockStandardType>.BaseType, TypedMockStandard<MockStandardType>.RemovalContext> adapter:
                () -> (any Adapter<T, T.ID, TypedMockStandard<MockStandardType>.BaseType, TypedMockStandard<MockStandardType>.RemovalContext>)
        ) {
            self.injectedData = injectedData
            self.adapter = adapter()
        }
        
        
        func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
            let asyncStream = AsyncStream<DataChange<T, T.ID>> {
                guard !self.injectedData.isEmpty else {
                    return nil
                }
                
                do {
                    try await Task.sleep(nanoseconds: 5_000_000) // 0.005 seconds
                } catch {}
                return self.injectedData.removeFirst()
            }
            
            Task {
                await standard.registerDataSource(adapter.transform(asyncStream))
            }
        }
    }
    
    class DataSourceTestApplicationDelegate<T: Hashable & Identifiable>: CardinalKitAppDelegate where T == T.ID {
        let dynamicDependencies: _DynamicDependenciesPropertyWrapper<TypedMockStandard<T>>
        let dataSourceExpecations: (DataChange<TypedMockStandard<T>.BaseType, TypedMockStandard<T>.RemovalContext>) async throws -> Void
        let finishedDataSourceSequence: (
            any TypedAsyncSequence<DataChange<TypedMockStandard<T>.BaseType,
            TypedMockStandard<T>.RemovalContext>>.Type
        ) async throws -> Void
        
        
        override var configuration: Configuration {
            Configuration(standard: TypedMockStandard<T>(
                dataSourceExpecations: dataSourceExpecations,
                finishedDataSourceSequence: finishedDataSourceSequence
            )) {
                DataSourceTestComponentInjector(dynamicDependencies)
            }
        }
        
        
        init(
            dynamicDependencies: _DynamicDependenciesPropertyWrapper<TypedMockStandard<T>>,
            dataSourceExpecations: @escaping (DataChange<TypedMockStandard<T>.BaseType, TypedMockStandard<T>.RemovalContext>) async throws -> Void,
            finishedDataSourceSequence: @escaping (
                any TypedAsyncSequence<DataChange<TypedMockStandard<T>.BaseType,
                TypedMockStandard<T>.RemovalContext>>.Type
            ) async throws -> Void
        ) {
            self.dynamicDependencies = dynamicDependencies
            self.dataSourceExpecations = dataSourceExpecations
            self.finishedDataSourceSequence = finishedDataSourceSequence
        }
    }
    
    actor IntToStringAdapterActor: Adapter {
        typealias InputElement = MockStandard.CustomDataSourceType<Int>
        typealias InputRemovalContext = InputElement.ID
        typealias OutputElement = MockStandard.CustomDataSourceType<String>
        typealias OutputRemovalContext = OutputElement.ID
        
        
        func transform(
            _ asyncSequence: some TypedAsyncSequence<DataChange<InputElement, InputRemovalContext>>
        ) async -> any TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>> {
            asyncSequence.map { element in
                element.map(
                    element: { MockStandard.CustomDataSourceType(id: String(describing: $0.id)) },
                    removalContext: { OutputRemovalContext($0.id) }
                )
            }
        }
    }
    
    actor DoubleToIntAdapterActor: SingleValueAdapter {
        typealias InputElement = MockStandard.CustomDataSourceType<Double>
        typealias InputRemovalContext = InputElement.ID
        typealias OutputElement = MockStandard.CustomDataSourceType<Int>
        typealias OutputRemovalContext = OutputElement.ID
        
        
        func transform(element: InputElement) -> OutputElement {
            MockStandard.CustomDataSourceType(id: OutputElement.ID(element.id))
        }
        
        func transform(removalContext: InputRemovalContext) -> OutputRemovalContext {
            OutputRemovalContext(removalContext.id)
        }
    }
    
    actor FloarToDoubleAdapterActor: SingleValueAdapter {
        typealias InputElement = MockStandard.CustomDataSourceType<Float>
        typealias InputRemovalContext = InputElement.ID
        typealias OutputElement = MockStandard.CustomDataSourceType<Double>
        typealias OutputRemovalContext = OutputElement.ID
        
        
        func transform(element: InputElement) -> OutputElement {
            MockStandard.CustomDataSourceType(id: OutputElement.ID(element.id))
        }
        
        func transform(removalContext: InputRemovalContext) -> OutputRemovalContext {
            OutputRemovalContext(removalContext.id)
        }
    }
    
    
    func testDataSourceRegistry() { // swiftlint:disable:this function_body_length
        let expecation = XCTestExpectation(description: "Recieved all required data source elements")
        expecation.assertForOverFulfill = true
        expecation.expectedFulfillmentCount = 3
        var dataChanges: [DataChange<TypedMockStandard<String>.BaseType, TypedMockStandard<String>.RemovalContext>] = []
        
        let delegate = DataSourceTestApplicationDelegate(
            dynamicDependencies: _DynamicDependenciesPropertyWrapper<TypedMockStandard<String>>(
                componentProperties: [
                    _DependencyPropertyWrapper(
                        wrappedValue: DataSourceTestComponent(
                            injectedData: [
                                .addition(MockStandard.CustomDataSourceType(id: 1)),
                                .addition(MockStandard.CustomDataSourceType(id: 2)),
                                .addition(MockStandard.CustomDataSourceType(id: 3)),
                                .removal(3),
                                .addition(MockStandard.CustomDataSourceType(id: 42))
                            ]
                        ) {
                            IntToStringAdapterActor()
                        }
                    ),
                    _DependencyPropertyWrapper(
                        wrappedValue: DataSourceTestComponent(
                            injectedData: [
                                .addition(MockStandard.CustomDataSourceType(id: 1.1)),
                                .addition(MockStandard.CustomDataSourceType(id: 2.2)),
                                .addition(MockStandard.CustomDataSourceType(id: 3.3)),
                                .removal(3.3),
                                .addition(MockStandard.CustomDataSourceType(id: 42.42))
                            ]
                        ) {
                            DoubleToIntAdapterActor()
                            IntToStringAdapterActor()
                        }
                    ),
                    _DependencyPropertyWrapper(
                        wrappedValue: DataSourceTestComponent(
                            injectedData: [
                                .addition(MockStandard.CustomDataSourceType(id: 1.1)),
                                .addition(MockStandard.CustomDataSourceType(id: 2.2)),
                                .addition(MockStandard.CustomDataSourceType(id: 3.3)),
                                .removal(3.3),
                                .addition(MockStandard.CustomDataSourceType(id: 42.42))
                            ]
                        ) {
                            FloarToDoubleAdapterActor()
                            DoubleToIntAdapterActor()
                            IntToStringAdapterActor()
                        }
                    )
                ]
            ),
            dataSourceExpecations: { dataChange in
                dataChanges.append(dataChange)
            },
            finishedDataSourceSequence: { _ in
                expecation.fulfill()
            }
        )
        
        let cardinalKit = delegate.cardinalKit
        cardinalKit.willFinishLaunchingWithOptions(UIApplication.shared, launchOptions: [:])
        
        wait(for: [expecation], timeout: 1)
        
        XCTAssertEqual(dataChanges.count, 15)
        XCTAssertEqual(dataChanges.filter { $0.id == "1" } .count, 3)
        XCTAssertEqual(dataChanges.filter { $0.id == "2" } .count, 3)
        XCTAssertEqual(dataChanges.filter { $0.id == "3" } .count, 6)
        XCTAssertEqual(dataChanges.filter { $0.id == "42" } .count, 3)
        
        XCTAssertEqual(
            dataChanges.filter {
                if case .addition(MockStandard.CustomDataSourceType(id: "3")) = $0 {
                    return true
                } else {
                    return false
                }
            }
                .count,
            3
        )
        XCTAssertEqual(
            dataChanges.filter {
                if case .removal("3") = $0 {
                    return true
                } else {
                    return false
                }
            }
                .count,
            3
        )
    }
}
