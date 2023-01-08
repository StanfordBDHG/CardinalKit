//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


@main
struct UITestsApp: App {
    enum Tests: String, CaseIterable, Identifiable {
        case account = "Account"
        case contacts = "Contacts"
        case firebaseDataStorage = "FirebaseDataStorage"
        case healthKit = "HealthKit"
        case localStorage = "LocalStorage"
        case onboardingTests = "OnboardingTests"
        case observableObject = "ObservableObject"
        case secureStorage = "SecureStorage"
        case views = "Views"
        
        
        var id: RawValue {
            self.rawValue
        }
        
        @MainActor
        @ViewBuilder
        func view(withNavigationPath path: Binding<NavigationPath>) -> some View {
            switch self {
            case .account:
                AccountTestsView()
            case .contacts:
                ContactsTestsView()
            case .firebaseDataStorage:
                FirebaseDataStorageTestsView()
            case .healthKit:
                HealthKitTestsView()
            case .localStorage:
                LocalStorageTestsView()
            case .onboardingTests:
                OnboardingTestsView(navigationPath: path)
            case .observableObject:
                ObservableObjectTestsView()
            case .secureStorage:
                SecureStorageTestsView()
            case .views:
                ViewsTestsView(navigationPath: path)
            }
        }
    }
    
    
    @UIApplicationDelegateAdaptor(TestAppDelegate.self) var appDelegate
    @State private var path = NavigationPath()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                List(Tests.allCases) { test in
                    NavigationLink(test.rawValue, value: test)
                }
                    .navigationDestination(for: Tests.self) { test in
                        test.view(withNavigationPath: $path)
                    }
                    .navigationTitle("UITest")
            }
                .cardinalKit(appDelegate)
        }
    }
}
