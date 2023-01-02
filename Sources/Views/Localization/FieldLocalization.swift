//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// A ``FieldLocalization`` describes a localization of a `TextField` instance using a ``FieldLocalization/title`` and ``FieldLocalization/placeholder``.
public struct FieldLocalization: Codable {
    /// The localized title of a `TextField`.
    public let title: String
    /// The localized placeholder of a `TextField`.
    public let placeholder: String
    
    
    /// Creates a new ``FieldLocalization`` instance.
    /// - Parameters:
    ///   - title: The title of a `TextField` following the localization mechanisms lined out in `StringProtocol.loalized`.
    ///   - placeholder: The placeholder of a `TextField` following the localization mechanisms lined out in `StringProtocol,loalized`.
    public init<Title: StringProtocol, Placeholder: StringProtocol>(title: Title, placeholder: Placeholder) {
        self.title = title.localized
        self.placeholder = placeholder.localized
    }
}
