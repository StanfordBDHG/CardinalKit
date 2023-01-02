//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Credentials that can be stored, updated, deleted, and retrieved from a ``SecureStorage/SecureStorage`` module.
public struct Credentials: Equatable, Identifiable {
    /// The username
    public var username: String
    /// The password associated to the ``Credentials/username``
    public var password: String
    
    
    /// Identifier of the ``Credentials`` representing the ``Credentials/username``
    public var id: String {
        username
    }
    
    
    /// Credentials that can be stored, updated, deleted, and retrieved from a ``SecureStorage/SecureStorage`` module.
    /// - Parameters:
    ///   - username: The username
    ///   - password: The password associated to the ``Credentials/username``
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
