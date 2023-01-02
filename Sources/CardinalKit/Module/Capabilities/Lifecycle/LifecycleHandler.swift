//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SwiftUI


/// Delegate methods related to the  `UIApplication` and ``CardinalKit/CardinalKit`` lifecycle
public protocol LifecycleHandler {
    /// Replicates  the `application(_: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool`
    /// functionality of the `UIApplicationDelegate`.
    ///
    /// Tells the delegate that the launch process has begun but that state restoration hasn’t occured.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - launchOptions: A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly. For information about the possible keys in this dictionary and how to handle them, see UIApplication.LaunchOptionsKey.
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    )
    
    /// Replicates  the `applicationWillTerminate(_: UIApplication)` functionality of the `UIApplicationDelegate`.
    ///
    /// Tells the delegate when the app is about to terminate.
    /// - Parameter application: Your singleton app object.
    func applicationWillTerminate(
        _ application: UIApplication
    )
}


extension LifecycleHandler {
    // A documentation for this methodd exists in the `LifecycleHandler` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) { }
    
    // A documentation for this methodd exists in the `LifecycleHandler` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func applicationWillTerminate(
        _ application: UIApplication
    ) { }
}


extension Array: LifecycleHandler where Element == LifecycleHandler {
    public func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) {
        for lifecycleHandler in self {
            lifecycleHandler.willFinishLaunchingWithOptions(application, launchOptions: launchOptions)
        }
    }
    
    public func applicationWillTerminate(
        _ application: UIApplication
    ) {
        for lifecycleHandler in self {
            lifecycleHandler.applicationWillTerminate(application)
        }
    }
}
