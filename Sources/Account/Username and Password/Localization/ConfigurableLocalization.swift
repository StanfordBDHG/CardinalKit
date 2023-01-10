//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Dependency injection mechanism for the localization of views.
///
/// Configure a view in the ``Account/Account`` module to either use the localization injected in the SwiftUI environment
/// using an ``Account/AccountService`` (``Account/ConfigurableLocalization/environment``)
/// or using a provided value (``Account/ConfigurableLocalization/value(_:)``).
public enum ConfigurableLocalization<T> {
    /// Use the localization injected in the SwiftUI environment using an ``Account/AccountService``.
    case environment
    /// Use a manually specified localization ``Localization`` subtype (e.g. ``Localization/Login-swift.struct``).
    case value(T)
}
