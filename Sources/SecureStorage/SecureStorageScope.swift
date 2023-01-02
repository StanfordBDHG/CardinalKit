//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Security


/// The ``SecureStorageScope`` defines how secure data is stored by the ``SecureStorage/SecureStorage`` component.
public enum SecureStorageScope: Equatable, Identifiable {
    /// Store the element in the Secure Enclave
    case secureEnclave(userPresence: Bool = false)
    /// Store the element in the Keychain
    ///
    /// The `userPresence` flag indicates if a retrieval of the item requires user presence.
    /// https://developer.apple.com/documentation/security/keychain_services/keychain_items/restricting_keychain_item_accessibility
    ///
    /// The `accessGroup` defines the access group used to store the element and share it across different applications:
    /// https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps
    case keychain(userPresence: Bool = false, accessGroup: String? = nil)
    /// Store the element in the Keychain and enable it to be synchronizable between different instances of user devices.
    ///
    /// The `userPresence` flag indicates if a retrieval of the item requires user presence.
    /// https://developer.apple.com/documentation/security/keychain_services/keychain_items/restricting_keychain_item_accessibility
    ///
    /// The `accessGroup` defines the access group used to store the element and share it across different applications:
    /// https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps
    case keychainSynchronizable(accessGroup: String? = nil)
    
    
    /// Store the element in the Secure Enclave
    public static let secureEnclave = secureEnclave()
    /// Store the element in the Keychain
    public static let keychain = keychain()
    /// Store the element in the Keychain and enable it to be synchronizable between different instances of user devices.
    public static let keychainSynchronizable = keychainSynchronizable()
    
    
    public var id: String {
        switch self {
        case let .keychain(userPresence, accessGroup):
            guard let accessGroup else {
                return "keychain.\(userPresence)"
            }
            return "keychain.\(userPresence).\(accessGroup)"
        case let .keychainSynchronizable(accessGroup):
            guard let accessGroup else {
                return "keychainSynchronizable"
            }
            return "keychainSynchronizable.\(accessGroup)"
        case .secureEnclave:
            return "secureEnclave"
        }
    }
    
    var userPresence: Bool {
        switch self {
        case let .secureEnclave(userPresence), let .keychain(userPresence, _):
            return userPresence
        case .keychainSynchronizable:
            return false
        }
    }
    
    var accessGroup: String? {
        switch self {
        case let .keychain(_, accessGroup), let .keychainSynchronizable(accessGroup):
            return accessGroup
        case .secureEnclave:
            return nil
        }
    }
    
    var accessControl: SecAccessControl? {
        get throws {
            // Follows https://developer.apple.com/documentation/security/keychain_services/keychain_items/restricting_keychain_item_accessibility
            guard case .keychainSynchronizable = self else {
                return nil
            }
            
            var secAccessControlCreateFlags: SecAccessControlCreateFlags = []
            let protection: CFTypeRef
            if self.userPresence {
                secAccessControlCreateFlags.insert(.userPresence)
                protection = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            } else {
                protection = kSecAttrAccessibleAfterFirstUnlock
            }
            
            guard let access = SecAccessControlCreateWithFlags(
                kCFAllocatorDefault,
                protection,
                secAccessControlCreateFlags,
                nil
            ) else {
                throw SecureStorageError.createFailed()
            }
            return access
        }
    }
}
