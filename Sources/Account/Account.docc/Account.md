# ``Account``

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Provides account-related functionalty including login, sign up, and reset password functionality.

## The Account Actor

The Account module provides several UI components that are powered using the ``Account/Account`` actor that must be injected into the SwiftUI environment.
Views like the ``Login`` and ``SignUp`` views use the ``Account/Account``'s ``AccountService``s provided in the initializer (``Account/Account/init(accountServices:)``) to 
populate the views.

More specialized views like the ``UsernamePasswordLoginView``, ``UsernamePasswordSignUpView``, ``UsernamePasswordResetPasswordView`` which are automatically provided if you use the
``Login`` view. It uses individual ``AccountService``s like the ``UsernamePasswordAccountService`` to populate the view content and react to user interactions.

You can use the following example using a CardinalKit Component and the configuration as a mechanism to inject the ``Account/Account`` actor into the SwiftUI
environment. Alternatively, you can use the `environmentObject(_:)` view modifier to manually inject the ``Account/Account`` actor into the SwiftUI environment.


The following example shows a CardinalKit component that creates a `User` class/actor defined within the project to store user-related information and passes it down to an
`ExampleUsernamePasswordAccountService` ``AccountService`` that can then modify the `User` instance based on the login or sign up procedure.
The `Component` injects the `Account` and `User` instances into the SwiftUI environment so they can be used by SwiftUI views:
```swift
final class ExampleAccountConfiguration<ComponentStandard: Standard>: Component, ObservableObjectProvider {
    private let account: Account
    private let user: User
    
    
    var observableObjects: [any ObservableObject] {
        [
            account,
            user
        ]
    }
    
    
    init() {
        self.user = User()
        let accountServices: [any AccountService] = [
            ExampleUsernamePasswordAccountService(user: user)
        ]
        self.account = Account(accountServices: accountServices)
    }
}
```

The `ExampleAccountConfiguration` must be added to an instance of `CardinalKitAppDelegate` to inform CardinalKit about your configuration and allow CardinalKit
to take the `observableObjects`, including the ``Account/Account`` actor, into the SwiftUI environment to make it available for your custom views
and, e.g., the ``Login`` and ``SignUp`` views:

```swift
class TestAppDelegate: CardinalKitAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: TestAppStandard()) {
            ExampleAccountConfiguration()
            // ...
        }
    }
}
```

## Account Views

You can then access the ``Account/Account`` actor in any SwiftUI view.
``AccountService``s must set the ``Account/Account/signedIn`` property to true if the user is signed in, making it possible for your to change your UI based on the
user's sign in status.

The following example shows an example view that uses the ``Account/Account`` actor to observe the user sign in state and offers the possibility to login or sign up
if the user is not signed in using a SwiftUI sheet to display the ``Login`` and ``SignUp`` views:
```swift
struct AccountExampleView: View {
    @EnvironmentObject var account: Account
    @State var showLogin = false
    @State var showSignUp = false
    
    
    var body: some View {
        List {
            if account.signedIn {
                Text("You are signed in!")
            } else {
                Button("Login") {
                    showLogin.toggle()
                }
                Button("SignUp") {
                    showSignUp.toggle()
                }
            }
        }
            .sheet(isPresented: $showLogin) {
                NavigationStack {
                    Login()
                }
            }
            .sheet(isPresented: $showSignUp) {
                NavigationStack {
                    SignUp()
                }
            }
            .onChange(of: account.signedIn) { signedIn in
                if signedIn {
                    showLogin = false
                    showSignUp = false
                }
            }
    }
}
```

## Topics

### Account Services

- <doc:CreateAnAccountService>
- ``Account/AccountService``
- ``Account/Account``

### Views

Views that can be used to provide login, sign up, and reset password flows using the defined ``Account/AccountService``s.

- ``Account/SignUp``
- ``Account/Login``

### Username And Password Account Service

The ``UsernamePasswordAccountService`` provides a starting point for a username and password-based ``AccountService`` that can be subclassed or extended
to fit the need of the specific application. The ``UsernamePasswordSignUpView``, ``UsernamePasswordLoginView``, and ``UsernamePasswordResetPasswordView``
all rely on the ``UsernamePasswordAccountService`` to be present in the SwiftUI environment.

- ``UsernamePasswordAccountService``
- ``UsernamePasswordSignUpView``
- ``UsernamePasswordLoginView``
- ``UsernamePasswordResetPasswordView``

### Email And Password Account Service

The ``EmailPasswordAccountService`` is a ``UsernamePasswordAccountService`` subclass providing email-related validation rules and 
customized view buttons enabling the creation of an email and password-based ``AccountService``.

- ``EmailPasswordAccountService``
