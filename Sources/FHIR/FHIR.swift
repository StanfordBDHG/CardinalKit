//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Foundation
@_exported @preconcurrency import ModelsR4
import XCTRuntimeAssertions


/// The ``FHIR`` standard provides a ``CardinalKit`` ``Standard`` that utilizes HL7® FHIR® as the central standard for your CardinalKit application.
///
///
/// If you import the FHIR module using `import FHIR` you can specify all FHIR compatible components and modules in the configuration builder:
/// ```
/// import FHIR
/// import CardinalKit
///
/// public class ExampleCardinalKitAppDelegate: CardinalKitAppDelegate {
///     override public var configuration: Configuration {
///         Configuration {
///             FHIRComponentExample()
///         }
///     }
/// }
/// ```
///
/// You can also manually specify the FHIR Standard by passing it into the ``Configuration`` initializer:
/// ```
/// import FHIR
/// import CardinalKit
///
/// public class ExampleCardinalKitAppDelegate: CardinalKitAppDelegate {
///     override public var configuration: Configuration {
///         Configuration(standard: FHIR()) {
///             FHIRComponentExample()
///         }
///     }
/// }
/// ```
public actor FHIR: Standard {
    /// The FHIR `Resource` type builds the ``Standard/BaseType`` of the ``FHIR`` standard.
    public typealias BaseType = Resource
    /// <#Description#>
    public typealias RemovalContext = FHIRRemovalContext
    
    
    /// <#Description#>
    public struct FHIRRemovalContext: Sendable, Identifiable {
        /// <#Description#>
        public let id: BaseType.ID
        /// <#Description#>
        public let resourceType: String
        
        
        /// <#Description#>
        /// - Parameters:
        ///   - id: <#id description#>
        ///   - resourceType: <#resourceType description#>
        public init(id: BaseType.ID, resourceType: String) {
            self.id = id
            self.resourceType = resourceType
        }
    }
    
    
    var resources: [String: ResourceProxy] = [:]
    
    @DataStorageProviders
    var dataSources: [any DataStorageProvider<FHIR>]
    
    
    public func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>) {
        _Concurrency.Task {
            for try await dateSourceElement in asyncSequence {
                switch dateSourceElement {
                case let .addition(resource):
                    guard let id = resource.id?.value?.string else {
                        continue
                    }
                    resources[id] = ResourceProxy(with: resource)
                    for dataSource in dataSources {
                        try await dataSource.process(.addition(resource))
                    }
                case let .removal(removalContext):
                    guard let id = removalContext.id?.value?.string else {
                        continue
                    }
                    resources[id] = nil
                    for dataSource in dataSources {
                        try await dataSource.process(.removal(removalContext))
                    }
                }
            }
        }
    }
}
