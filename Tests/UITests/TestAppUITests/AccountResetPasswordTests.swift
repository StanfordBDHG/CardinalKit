//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class AccountResetPasswordTests: TestAppUITests {
    func testResetPasswordUsernameComponents() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Account"].tap()
        app.buttons["Login"].tap()
        app.buttons["Username and Password"].tap()
        app.buttons["Forgot Password?"].tap()
        XCTAssertTrue(app.navigationBars.buttons["Login"].exists)
        
        let usernameField = "Enter your username ..."
        let username = "lelandstanford"
        let buttonTitle = "Reset Password"
        let navigationBarButtonTitle = "Login"
        
        app.testPrimaryButton(enabled: false, title: buttonTitle, navigationBarButtonTitle: navigationBarButtonTitle)
        
        app.enter(value: username, in: usernameField)
        
        app.testPrimaryButton(enabled: true, title: buttonTitle, navigationBarButtonTitle: navigationBarButtonTitle)
        
        XCTAssertTrue(app.staticTexts["Sent out a link to reset the password."].waitForExistence(timeout: 6.0))
    }
    
    func testResetPasswordEmailComponents() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Account"].tap()
        app.buttons["Login"].tap()
        app.buttons["Email and Password"].tap()
        app.buttons["Forgot Password?"].tap()
        XCTAssertTrue(app.navigationBars.buttons["Login"].exists)
        
        let usernameField = "Enter your email ..."
        let username = "lelandstanford@stanford.edu"
        let buttonTitle = "Reset Password"
        let navigationBarButtonTitle = "Login"
        
        app.testPrimaryButton(enabled: false, title: buttonTitle, navigationBarButtonTitle: navigationBarButtonTitle)
        
        app.enter(value: String(username.dropLast(4)), in: usernameField)
        
        XCTAssertTrue(app.staticTexts["The entered email is not correct."].waitForExistence(timeout: 1.0))
        
        app.delete(count: username.dropLast(4).count, in: usernameField)
        app.enter(value: username, in: usernameField)
        
        app.testPrimaryButton(enabled: true, title: buttonTitle, navigationBarButtonTitle: navigationBarButtonTitle)
        
        XCTAssertTrue(app.staticTexts["Sent out a link to reset the password."].waitForExistence(timeout: 6.0))
    }
}
