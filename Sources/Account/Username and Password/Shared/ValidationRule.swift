//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A rule used for validating text along with a message to display if the validation fails.
///
/// The following example demonstrates a ``ValidationRule`` using a regex expression for an email.
/// ```
/// ValidationRule(
///     regex: try? Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"),
///     message: "The entered email is not correct."
/// )
/// ```
public struct ValidationRule: Decodable {
    enum CodingKeys: String, CodingKey {
        case rule
        case message
    }
    
    
    private let rule: (String) -> Bool
    private let message: String
    
    
    /// Creates a validation rule from an escaping closure
    ///
    /// - Parameters:
    ///   - rule: An escaping closure that validates a `String` and returns a boolean result
    ///   - message: A `String` message to display if validation fails
    public init(rule: @escaping (String) -> Bool, message: String) {
        self.rule = rule
        self.message = message
    }
    
    /// Creates a validation rule from a regular expression
    ///
    /// - Parameters:
    ///   - regex: A `Regex` regular expression to match for validating text
    ///   - message: A `String` message to display if validation fails
    public init(regex: Regex<AnyRegexOutput>, message: String) {
        self.rule = { input in
            (try? regex.wholeMatch(in: input) != nil) ?? false
        }
        self.message = message
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let regexString = try values.decode(String.self, forKey: .rule)
        let regex = try Regex<AnyRegexOutput>(regexString)
        
        let message = try values.decode(String.self, forKey: .message)
        
        self.init(regex: regex, message: message)
    }
    
    /// Validates the contents of a `String` and returns a `String` error message if validation fails
    func validate(_ input: String) -> String? {
        guard !rule(input) else {
            return nil
        }
        
        return message
    }
}
