//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public protocol FirestoreElement: Encodable, Identifiable, Sendable where ID == String {
    /// <#Description#>
    var collectionPath: String { get }
}
