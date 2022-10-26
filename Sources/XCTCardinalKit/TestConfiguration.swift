//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI
@_exported import XCTest


public class TestComponent<ComponentStandard: Standard>: ObservableObject, Component, ObservableObjectComponent {
    let expectation: XCTestExpectation
    
    
    public init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }
    
    
    public func configure(cardinalKit: CardinalKit<ComponentStandard>) {
        cardinalKit.typedCollection.set(TestComponent.self, to: self)
        expectation.fulfill()
    }
}
