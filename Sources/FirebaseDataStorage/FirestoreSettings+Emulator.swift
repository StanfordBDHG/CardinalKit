//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FirebaseFirestore

extension FirestoreSettings: @unchecked Sendable {
    /// The emulator settings define the default settings when using the Firebase emulator suite as described at [Connect your app to the Cloud Firestore Emulator](https://firebase.google.com/docs/emulator-suite/connect_firestore).
    public static var emulator: FirestoreSettings {
        let settings = FirestoreSettings()
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        return settings
    }
}
