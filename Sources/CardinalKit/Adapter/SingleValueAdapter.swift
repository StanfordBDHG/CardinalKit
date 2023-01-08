//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``SingleValueAdapter`` is a ``Adapter`` that can be used to more simply transform data using the
/// ``SingleValueAdapter/transform(element:)`` and ``SingleValueAdapter/transform(id:)`` functions.
///
/// See ``Adapter`` for more detail about data source registry adapters.
public protocol SingleValueAdapter<InputElement, InputRemovalContext, OutputElement, OutputRemovalContext>: Adapter {
    /// Map the element of the transformed async streams from additions.
    /// - Parameter element: The element that should be transformed.
    /// - Returns: Returns the transformed element
    func transform(element: InputElement) -> OutputElement
    
    /// Map the element's removal of the transformed async streams from removals.
    /// - Parameter removalContext: The element's removal context that should be transformed.
    /// - Returns: Returns the transformed removal context.
    func transform(removalContext: InputRemovalContext) -> OutputRemovalContext
}


extension SingleValueAdapter {
    // A documentation for this methodd exists in the `Adapter` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func transform(
        _ asyncSequence: some TypedAsyncSequence<DataChange<InputElement, InputRemovalContext>>
    ) async -> any TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>> {
        asyncSequence.map { [self] element in
            switch element {
            case let .addition(element):
                return await .addition(transform(element: element))
            case let .removal(elementId):
                return await .removal(transform(removalContext: elementId))
            }
        }
    }
}
