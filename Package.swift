// swift-tools-version:5.7

//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "CardinalKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "Account", targets: ["Account"]),
        .library(name: "CardinalKit", targets: ["CardinalKit"]),
        .library(name: "Contact", targets: ["Contact"]),
        .library(name: "FHIR", targets: ["FHIR"]),
        .library(name: "FirebaseDataStorage", targets: ["FirebaseDataStorage"]),
        .library(name: "HealthKitDataSource", targets: ["HealthKitDataSource"]),
        .library(name: "LocalStorage", targets: ["LocalStorage"]),
        .library(name: "Onboarding", targets: ["Onboarding"]),
        .library(name: "Scheduler", targets: ["Scheduler"]),
        .library(name: "SecureStorage", targets: ["SecureStorage"]),
        .library(name: "Views", targets: ["Views"]),
        .library(name: "XCTRuntimeAssertions", targets: ["XCTRuntimeAssertions"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/FHIRModels", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.3.0")
    ],
    targets: [
        .target(
            name: "Account",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "Views")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "CardinalKit",
            dependencies: [
                .target(name: "XCTRuntimeAssertions")
            ]
        ),
        .testTarget(
            name: "CardinalKitTests",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "XCTRuntimeAssertions")
            ]
        ),
        .target(
            name: "Contact",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "Views")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "FHIR",
            dependencies: [
                .target(name: "CardinalKit"),
                .product(name: "ModelsR4", package: "FHIRModels")
            ]
        ),
        .testTarget(
            name: "FHIRTests",
            dependencies: [
                .target(name: "FHIR")
            ]
        ),
        .target(
            name: "FirebaseDataStorage",
            dependencies: [
                .target(name: "CardinalKit"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
            ]
        ),
        .target(
            name: "HealthKitDataSource",
            dependencies: [
                .target(name: "CardinalKit")
            ]
        ),
        .target(
            name: "LocalStorage",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "SecureStorage")
            ]
        ),
        .testTarget(
            name: "LocalStorageTests",
            dependencies: [
                .target(name: "LocalStorage")
            ]
        ),
        .target(
            name: "Onboarding",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "Views")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "Scheduler",
            dependencies: [
                .target(name: "CardinalKit")
            ]
        ),
        .testTarget(
            name: "SchedulerTests",
            dependencies: [
                .target(name: "Scheduler")
            ]
        ),
        .target(
            name: "SecureStorage",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "XCTRuntimeAssertions")
            ]
        ),
        .target(
            name: "Views"
        ),
        .target(
            name: "XCTRuntimeAssertions"
        ),
        .testTarget(
            name: "XCTRuntimeAssertionsTests",
            dependencies: [
                .target(name: "XCTRuntimeAssertions")
            ]
        )
    ]
)
