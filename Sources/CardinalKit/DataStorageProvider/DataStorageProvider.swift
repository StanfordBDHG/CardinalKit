//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``DataStorageProvider``  determines a ``Component`` used to process data from a ``Standard``.
/// A ``Standard`` instance can use the ``Standard/DataStorageProviders`` property wrapper to access all related ``DataStorageProvider``s.
///
/// The following example uses an ``EncodableAdapter`` and ``IdentityEncodableAdapter`` to transform elements to an `Encodable` representation:
/// ```
/// struct DataStorageUploadable: Encodable, Identifiable {
///     let id: String
///     let element: Encodable
///
///
///     func encode(to encoder: Encoder) throws {
///         try element.encode(to: encoder)
///     }
/// }
///
/// actor DataStorageExample<ComponentStandard: Standard>: DataStorageProvider {
///     typealias DataStorageExampleAdapter = SingleValueAdapter<ComponentStandard.BaseType, ComponentStandard.RemovalContext, DataStorageUploadable, String>
///
///
///     let adapter: any DataStorageExampleAdapter
///
///
///     init(@AdapterBuilder<DataStorageUploadable, String> adapter: () -> (any DataStorageExampleAdapter)) {
///         self.adapter = adapter()
///     }
///
///
///     func process(_ element: DataChange<ComponentStandard.BaseType, ComponentStandard.RemovalContext>) async throws {
///         switch element {
///             case let .addition(element):
///                 let transformedElement = await adapter.transform(element: element)
///                 // Upload the `transformedElement` ...
///             case let .removal(removalContext):
///                 let transformedRemovalContext = await adapter.transform(removalContext: removalContext)
///                 // Process the `transformedRemovalContext` ...
///         }
///     }
/// }
/// ```
public protocol DataStorageProvider<ComponentStandard>: Actor, Component {
    /// The ``DataStorageProvider/process(_:)`` function is called for every element should be handled by the ``DataStorageProvider``
    /// - Parameter element: The ``DataChange`` defines if the element should be added or deleted.
    func process(_ element: DataChange<ComponentStandard.BaseType, ComponentStandard.RemovalContext>) async throws
}
