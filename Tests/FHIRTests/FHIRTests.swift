//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
@testable import FHIR
import XCTest


final class DataStorageProviderTests: XCTestCase {
    private enum MockUpload {
        case post(String)
        case delete(String)
        
        
        func assertPost(is value: String) {
            guard case let .post(test) = self else {
                XCTFail("Expected a .post and got: \(self)")
                return
            }
            XCTAssertEqual(test, value)
        }
        
        func assertDelete(is value: String) {
            guard case let .delete(test) = self else {
                XCTFail("Expected a .delete and got: \(self)")
                return
            }
            XCTAssertEqual(test, value)
        }
    }
    
    
    private actor FHIRDataStorageExample: DataStorageProvider {
        typealias ComponentStandard = FHIR
        
        
        let mockUpload: (MockUpload) -> Void
        
        
        init(mockUpload: @escaping (MockUpload) -> Void) {
            self.mockUpload = mockUpload
        }
        
        
        func process(_ element: DataChange<ComponentStandard.BaseType, ComponentStandard.RemovalContext>) async throws {
            switch element {
            case let .addition(element):
                let data = try JSONEncoder().encode(element)
                let string = String(decoding: data, as: UTF8.self)
                mockUpload(.post(string))
            case let .removal(removalContext):
                mockUpload(.delete(removalContext.id.description))
            }
        }
    }
    
    private class DataStorageProviderApplicationDelegate: CardinalKitAppDelegate {
        let mockUpload: (MockUpload) -> Void
        
        
        override var configuration: Configuration {
            Configuration {
                FHIRDataStorageExample(mockUpload: mockUpload)
            }
        }
        
        
        init(mockUpload: @escaping (MockUpload) -> Void) {
            self.mockUpload = mockUpload
        }
    }
    
    
    @MainActor
    func testDataStorageProviderTests() async throws {
        let expectation = expectation(description: "Timeout Expection")
        expectation.isInverted = true
        
        var count = 0
        let delegate = DataStorageProviderApplicationDelegate { mockUpload in
            switch count {
            case 0:
                mockUpload.assertPost(is: #"{"status":"final","id":"1","code":{},"resourceType":"Observation"}"#)
            case 1:
                mockUpload.assertPost(is: #"{"status":"final","id":"2","code":{},"resourceType":"Observation"}"#)
            case 2:
                mockUpload.assertPost(is: #"{"status":"final","id":"3","code":{},"resourceType":"Observation"}"#)
            case 3:
                mockUpload.assertDelete(is: "1")
            default:
                XCTFail("Too many calls to the mock upload function.")
            }
            count += 1
        }
        
        let observation1 = Observation(
            code: CodeableConcept(),
            id: "1",
            status: FHIRPrimitive<ObservationStatus>(.final)
        )
        let observation2 = Observation(
            code: CodeableConcept(),
            id: "2",
            status: FHIRPrimitive<ObservationStatus>(.final)
        )
        let observation3 = Observation(
            code: CodeableConcept(),
            id: "3",
            status: FHIRPrimitive<ObservationStatus>(.final)
        )
        let observationNilId = Observation(
            code: CodeableConcept(),
            status: FHIRPrimitive<ObservationStatus>(.final)
        )
        
        
        let cardinalKit = try XCTUnwrap(delegate.cardinalKit as? CardinalKit<FHIR>)
        await cardinalKit.standard.registerDataSource(
            asyncStream: AsyncStream { continuation in
                continuation.yield(.addition(observation1))
                continuation.yield(.addition(observation2))
                continuation.yield(.addition(observation3))
                continuation.yield(.addition(observationNilId))
                continuation.yield(.removal(FHIR.RemovalContext(id: nil, resourceType: "Observation")))
                continuation.yield(.removal(FHIR.RemovalContext(id: "1", resourceType: "Observation")))
            }
        )
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(count, 4)
    }
    
    
    func testFHIRIdentifiable() {
        let contentFHIRString: FHIRPrimitive<FHIRString>? = "42"
        XCTAssertEqual(contentFHIRString.description, "42")
        
        let emptyFHIRString: FHIRPrimitive<FHIRString>? = ""
        XCTAssertEqual(emptyFHIRString.description, "")
        
        let nilFHIRString: FHIRPrimitive<FHIRString>? = FHIRPrimitive(nil)
        XCTAssertEqual(nilFHIRString.description, "")
        
        let nilFHIRPrimitive: FHIRPrimitive<FHIRString>? = nil
        XCTAssertEqual(nilFHIRPrimitive.description, "")
        
        let descriptionFHIRString = FHIRPrimitive<FHIRString>?("43")
        XCTAssertEqual(descriptionFHIRString, "43")
    }
}
