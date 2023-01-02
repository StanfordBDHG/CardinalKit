//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// An ``EncodableAdapter`` can be used to transform a type to an `Encodable` instance. It is typically used in instantiations of a ``DataStorageProvider``.
///
/// You can refer to the ``IdentityEncodableAdapter`` if you require a default adapter for a type that already conforms to all required protocols.
public protocol EncodableAdapter<InputType, ID>: Actor {
    /// The input type conforming to `Sendable` and `Identifiable` where the `InputType.ID` is `Sendable` as well.
    associatedtype InputType: Sendable, Identifiable where InputType.ID: Sendable
    /// The ouput of the ``transform(id:)`` function that has to confrom to `Sendable` and `Hashable`.
    associatedtype ID: Sendable, Hashable
    
    
    /// Transforms an element to an `Encodable` and `Sendable` value.
    /// - Parameter element: The element that is tranformed.
    /// - Returns: Returns an element conforming to an `Encodable` and `Sendable`
    func transform(element: InputType) async -> any Encodable & Sendable
    
    /// Transforms an id to an ``EncodableAdapter/ID`` instance.
    /// - Parameter id: The ``EncodableAdapter/InputType``'s `ID` type that is transformed.
    /// - Returns: The transformed ``EncodableAdapter/ID`` instance.
    func transform(id: InputType.ID) async -> ID
}
