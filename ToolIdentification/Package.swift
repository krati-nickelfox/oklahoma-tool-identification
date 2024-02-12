// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToolIdentification",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ToolIdentification",
            targets: ["ToolIdentification"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa", from: "10.40.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ToolIdentification",
            dependencies: [
                .product(name: "RealmSwift", package: "Realm")
            ]),
        .testTarget(
            name: "ToolIdentificationTests",
            dependencies: ["ToolIdentification"]),
    ]
)
