//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// The collected date instantiated by the sign up views.
public struct SignUpValues: Sendable {
    /// The username as inputted in the sign up user interface.
    public let username: String
    /// The password as inputted in the sign up user interface.
    public let password: String
    /// The name as inputted in the sign up user interface.
    public let name: PersonNameComponents
    /// The self-identified gender as inputted in the sign up user interface.
    public let genderIdentity: GenderIdentity?
    /// The date of birth as inputted in the sign up user interface.
    public let dateOfBirth: Date?
    
    
    /// - Parameters:
    ///   - username: The username as inputted in the sign-up user interface.
    ///   - password: The password as inputted in the sign-up user interface.
    ///   - name: The name as inputted in the sign-up user interface.
    ///   - genderIdentity: The self-identified gender as inputted in the sign-up user interface.
    ///   - dateOfBirth: The date of birth as inputted in the sign-up user interface.
    init(username: String, password: String, name: PersonNameComponents, genderIdentity: GenderIdentity?, dateOfBirth: Date?) {
        self.username = username
        self.password = password
        self.name = name
        self.genderIdentity = genderIdentity
        self.dateOfBirth = dateOfBirth
    }
}
