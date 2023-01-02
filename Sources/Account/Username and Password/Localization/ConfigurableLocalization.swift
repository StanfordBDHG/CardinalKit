//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Describes a localization configuration
public enum ConfigurableLocalization<T> {
    /// The default localization
    case environment
    /// The specific localization for a ``Localization`` subtype (e.g. ``Localization/Login-swift.struct``)
    case value(T)
}
