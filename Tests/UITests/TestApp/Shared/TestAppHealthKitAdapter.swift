//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
@preconcurrency import HealthKit


actor TestAppHealthKitAdapter: SingleValueAdapter {
    typealias InputElement = HKSample
    typealias InputRemovalContext = UUID
    typealias OutputElement = TestAppStandard.BaseType
    typealias OutputRemovalContext = TestAppStandard.RemovalContext
    
    
    func transform(element: InputElement) -> OutputElement {
        TestAppStandard.BaseType(id: element.sampleType.identifier)
    }
    
    func transform(removalContext: InputRemovalContext) -> OutputRemovalContext {
        OutputRemovalContext(id: removalContext.uuidString)
    }
}
