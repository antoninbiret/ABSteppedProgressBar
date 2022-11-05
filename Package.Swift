// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "ABSteppedProgressBar",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "ABSteppedProgressBar",
            targets: ["ABSteppedProgressBar"]),
    ],
    dependencies: [
        // no dependencies
    ],
    targets: [
        .target(
            name: "ABSteppedProgressBar",
            path: "Sources",
            dependencies: [])
    ]
)
