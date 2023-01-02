//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// Represents a set of options for data to collect from the user on the sign up form
public struct SignUpOptions: OptionSet {
    /// Option to collect a username and password
    public static let usernameAndPassword = SignUpOptions(rawValue: 1 << 0)
    /// Option to collect a name
    public static let name = SignUpOptions(rawValue: 1 << 1)
    /// Option to collect a gender identity
    public static let genderIdentity = SignUpOptions(rawValue: 1 << 2)
    /// Option to collect a date of birth
    public static let dateOfBirth = SignUpOptions(rawValue: 1 << 3)
    
    /// A default set of signup options, including username and password, name, gender identity, and date of birth
    public static let `default`: SignUpOptions = [.usernameAndPassword, .name, .genderIdentity, .dateOfBirth]
    
    
    public let rawValue: Int
    
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
