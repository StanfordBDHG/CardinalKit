# Create an Account Service

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Account services describe the mechanism for account management components to display login, signUp, and account-related UI elements.

## Create Your Account Service

You can create new account services by conforming to the ``AccountService`` protocol.
An ``AccountService`` has to provide an ``AccountService/loginButton`` and ``AccountService/signUpButton-8r2hk`` that is used in the
``Login`` and ``SignUp`` views.

The ``AccountService/inject(account:)`` function provides an ``AccountService`` to get access to the ``Account/Account`` actor.
An ``AccountService`` generally stores the ``Account/Account`` actor using a weak reference to avoid reference cycles.

The following example demonstrates an example of an ``AccountService``:
```swift
class ExampleAccountService: @unchecked Sendable, AccountService, ObservableObject {
    weak var account: Account?
    
    
    var loginButton: AnyView {
        AnyView(
            NavigationLink {
                Text("Your Login View ...")
                    .environmentObject(self)
            } label: {
                Text("Login")
            }
        )
    }
    
    var signUpButton: AnyView {
        AnyView(
            NavigationLink {
                Text("Your Sign Up View ...")
                    .environmentObject(self)
            } label: {
                Text("Sign Up")
            }
        )
    }
    

    public init() { }
    
    
    func inject(account: Account) {
        self.account = account
    }
    
    func login(/* ... */) async throws { }
    
    func signUp(/* ... */) async throws { }
}
```

## Username Password-based Account Services

The ``UsernamePasswordAccountService`` provides a starting point for a username and password-based ``AccountService`` that can be subclassed or extended
to fit the need of the specific application. The ``UsernamePasswordSignUpView``, ``UsernamePasswordLoginView``, and ``UsernamePasswordResetPasswordView``
all rely on the ``UsernamePasswordAccountService`` to be present in the SwiftUI environment.

The following example uses the `User` type defined below to login and sign up a user.
```swift
actor User: ObservableObject {
    @MainActor @Published var username: String?
    @MainActor @Published var name = PersonNameComponents()
    @MainActor @Published var gender: GenderIdentity?
    @MainActor @Published var dateOfBirth: Date?
    
    
    init(
        username: String? = nil,
        name: PersonNameComponents = PersonNameComponents(),
        gender: GenderIdentity? = nil,
        dateOfBirth: Date? = nil
    ) {
        Task { @MainActor in
            self.username = username
            self.name = name
            self.gender = gender
            self.dateOfBirth = dateOfBirth
        }
    }
}
```

Subclassing ``UsernamePasswordAccountService`` enables a built-in functionality to handle username and password-related sign up and login functionality.
The following example demonstrates subclassing the ``UsernamePasswordAccountService`` with custom login and sign up functions.
```swift
class ExampleUsernamePasswordAccountService: UsernamePasswordAccountService {
    let user: User
    
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    
    override func login(username: String, password: String) async throws {
        try await Task.sleep(for: .seconds(5))
        
        guard username == "lelandstanford", password == "StanfordRocks123!" else {
            throw MockAccountServiceError.wrongCredentials
        }
        
        await MainActor.run {
            account?.signedIn = true
            user.username = username
        }
    }
    
    
    override func signUp(signUpValues: SignUpValues) async throws {
        try await Task.sleep(for: .seconds(5))
        
        guard signUpValues.username != "lelandstanford" else {
            throw MockAccountServiceError.usernameTaken
        }
        
        await MainActor.run {
            account?.signedIn = true
            user.username = signUpValues.username
            user.name = signUpValues.name
            user.dateOfBirth = signUpValues.dateOfBirth
            user.gender = signUpValues.genderIdentity
        }
    }
    
    override func resetPassword(username: String) async throws {
        try await Task.sleep(for: .seconds(5))
    }
}

```

## Build-in Account Services

### Account Service

- ``AccountService``

### Username And Password Account Service

The ``UsernamePasswordAccountService`` provides a username and password-account management.

- ``UsernamePasswordAccountService``
- ``UsernamePasswordSignUpView``
- ``UsernamePasswordLoginView``
- ``UsernamePasswordResetPasswordView``

### Email And Password Account Service

The ``EmailPasswordAccountService`` is a ``UsernamePasswordAccountService`` subclass providing email related validation rules and 
customized view buttons enabeling the creation of an email and password-based ``AccountService``.

- ``EmailPasswordAccountService``
