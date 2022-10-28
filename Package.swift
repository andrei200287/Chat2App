// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chat2App",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Chat2App",
            targets: ["Chat2App"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/MessageKit/MessageKit", .upToNextMajor(from: "4.1.1")),
        .package(url: "https://github.com/SwiftKickMobile/SwiftMessages", .upToNextMajor(from: "9.0.6")),
        .package(url: "https://github.com/vpeschenkov/LetterAvatarKit", .upToNextMajor(from: "1.2.5")),
        .package(url: "https://github.com/devicekit/DeviceKit", .upToNextMajor(from: "4.7.0")),
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.4.1")),
        //
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Chat2App",
            dependencies: ["DeviceKit", "MessageKit", "LetterAvatarKit", "Kingfisher", "SwiftMessages"],
            path: "Sources",
            swiftSettings: [SwiftSetting.define("IS_SPM")]),
        .testTarget(
            name: "Chat2AppTests",
            dependencies: ["Chat2App"],
            path: "Tests"),
    ]
)
