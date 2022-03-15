// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AcaiaSDK",
    products: [
        .library(
            name: "AcaiaSDK",
            targets: ["AcaiaSDK"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "AcaiaSDK",
            path: "AcaiaSDK.xcframework"
        ),
    ]
)
