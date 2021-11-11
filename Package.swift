// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    
    name: "acaia_sdk_ios",
    
    products: [
        .library(
            name: "acaia_sdk_ios",
            targets: ["acaia_sdk_ios"]
        ),
    ],
    
    targets: [
        .binaryTarget(
            name: "acaia_sdk_ios",
            path: "AcaiaSDK.xcframework"
        ),
        
//        .testTarget(
//            name: "acaia_sdk_iosTests",
//            dependencies: ["acaia_sdk_ios"]
//        ),
    ]
)
