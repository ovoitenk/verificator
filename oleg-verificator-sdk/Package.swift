// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VerificatorSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "VerificatorSDK",
            targets: ["VerificatorSDK"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "VerificatorSDK",
            dependencies: [],
            resources: [
              .process("Resources/google_api_credentials.json")
            ]
        ),
        .testTarget(
            name: "VerificatorSDK-Tests",
            dependencies: ["VerificatorSDK"]),
    ]
)
