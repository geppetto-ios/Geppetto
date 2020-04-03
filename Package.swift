// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Geppetto",
                      platforms: [
                        .iOS(.v12)],
                      products: [
                        .library(
                            name: "Geppetto",
                            targets: ["Geppetto"])
    ],
                      targets: [
                        .target(
                            name: "Geppetto",
                            path: "Sources"
                        )
    ]
)
