//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``Adapter`` can be used to transfrom an input `DataChange` (`InputElement` and `InputRemovalContext`)
/// to an output `DataChange` (`OutputElement` and `OutputRemovalContext`).
///
/// Use the ``AdapterBuilder`` to offer developers to option to pass in a `Adapter` instance to your components.
public protocol Adapter<InputElement, InputRemovalContext, OutputElement, OutputRemovalContext>: Actor {
    /// The input element of the ``Adapter``
    associatedtype InputElement: Identifiable, Sendable where InputElement.ID: Sendable
    /// The input removal context of the ``Adapter``
    associatedtype InputRemovalContext: Identifiable, Sendable where InputElement.ID == InputRemovalContext.ID
    /// The output element of the ``Adapter``
    associatedtype OutputElement: Identifiable, Sendable where OutputElement.ID: Sendable
    /// The output removal context of the ``Adapter``
    associatedtype OutputRemovalContext: Identifiable, Sendable where OutputElement.ID == OutputRemovalContext.ID
    
    
    /// Transforms any `TypedAsyncSequence<DataChange<InputElement, InputRemovalContext>>` to an `TypedAsyncSequence` with
    /// the `TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>>` generic constraint fulfilling the transformation,
    ///
    /// Implement this method in an instance of a `Adapter`.
    /// - Parameter asyncSequence: The input `TypedAsyncSequence`.
    /// - Returns: The transformed `TypedAsyncSequence`.
    func transform(
        _ asyncSequence: some TypedAsyncSequence<DataChange<InputElement, InputRemovalContext>>
    ) async -> any TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>>
}
