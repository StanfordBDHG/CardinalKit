//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class AccountSignUpTests: TestAppUITests {
    func testSignUpUsernameComponents() throws {
        disablePasswordAutofill()
        
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Account"].tap()
        app.buttons["SignUp"].tap()
        app.buttons["Username and Password"].tap()
        
        let usernameField = "Enter your username ..."
        let username = "lelandstanford"
        let usernameReplacement = "lelandstanford2"
        
        try signUpUsername(
            usernameField: usernameField,
            username: username,
            usernameReplacement: usernameReplacement
        )
    }
    
    func testSignUpEmailComponents() throws {
        disablePasswordAutofill()
        
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Account"].tap()
        app.buttons["SignUp"].tap()
        app.buttons["Email and Password"].tap()
        
        let usernameField = "Enter your email ..."
        let username = "lelandstanford@stanford.edu"
        let usernameReplacement = "lelandstanford2@stanford.edu"
        
        try signUpUsername(
            usernameField: usernameField,
            username: username,
            usernameReplacement: usernameReplacement
        ) {
            app.enter(value: String(username.dropLast(4)), in: usernameField)
            app.testPrimaryButton(enabled: false, title: "Sign Up")

            XCTAssertTrue(app.staticTexts["The entered email is not correct."].exists)
            
            app.delete(count: username.count, in: usernameField)
        }
    }
    
    func signUpUsername(
        usernameField: String,
        username: String,
        usernameReplacement: String,
        initialTests: () -> Void = { }
    ) throws {
        let app = XCUIApplication()
        let buttonTitle = "Sign Up"
        
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        initialTests()
        
        app.enter(value: username, in: usernameField)
        app.testPrimaryButton(enabled: false, title: buttonTitle)

        let passwordField = "Enter your password ..."
        let password = "StanfordRocks123!"
        app.enter(value: password, in: passwordField, secureTextField: true)
        app.testPrimaryButton(enabled: false, title: buttonTitle)

        let passwordRepeatField = "Repeat your password ..."
        var passwordRepeat = "StanfordRocks123"
        app.enter(value: passwordRepeat, in: passwordRepeatField, secureTextField: true)
        app.testPrimaryButton(enabled: false, title: buttonTitle)

        XCTAssertTrue(app.staticTexts["The entered passwords are not equal."].exists)

        app.delete(count: passwordRepeat.count, in: passwordRepeatField, secureTextField: true)
        passwordRepeat = password
        app.enter(value: passwordRepeat, in: passwordRepeatField, secureTextField: true)
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        app.datePickers.firstMatch.tap()
        app.staticTexts["Date of Birth"].tap()
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        app.staticTexts["Choose not to answer"].tap()
        app.buttons["Male"].tap()
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        let givenNameField = "Enter your given name ..."
        let givenName = "Leland"
        app.enter(value: givenName, in: givenNameField)
        app.testPrimaryButton(enabled: false, title: buttonTitle)

        let familyNameField = "Enter your family name ..."
        let familyName = "Stanford"
        app.enter(value: familyName, in: familyNameField)
        app.testPrimaryButton(enabled: true, title: buttonTitle)
        
        XCTAssertTrue(app.alerts["Username is already taken"].waitForExistence(timeout: 10.0))
        app.alerts["Username is already taken"].scrollViews.otherElements.buttons["OK"].tap()
        
        app.delete(count: username.count, in: usernameField)
        app.enter(value: usernameReplacement, in: usernameField)
        app.testPrimaryButton(enabled: true, title: buttonTitle)
        
        XCTAssertTrue(app.collectionViews.staticTexts[usernameReplacement].waitForExistence(timeout: 10.0))
    }
    
    
    func disablePasswordAutofill() {
        let settingsApp = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        settingsApp.terminate()
        settingsApp.launch()
        
        if settingsApp.staticTexts["PASSWORDS"].waitForExistence(timeout: 0.5) {
            settingsApp.staticTexts["PASSWORDS"].tap()
        }
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        if springboard.secureTextFields["Passcode field"].waitForExistence(timeout: 20) {
            let passcodeInput = springboard.secureTextFields["Passcode field"]
            passcodeInput.tap()
            passcodeInput.typeText("1234\r")
        } else {
            XCTFail("Could not enter the passcode in the device to enter the password section in the settings app.")
            return
        }
        
        XCTAssertTrue(settingsApp.tables.cells["PasswordOptionsCell"].waitForExistence(timeout: 5.0))
        settingsApp.tables.cells["PasswordOptionsCell"].buttons["chevron"].tap()
        if settingsApp.switches["AutoFill Passwords"].value as? String == "1" {
            settingsApp.switches["AutoFill Passwords"].tap()
        }
    }
}
