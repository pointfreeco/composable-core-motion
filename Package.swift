// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "composable-core-motion",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "ComposableCoreMotion",
      targets: ["ComposableCoreMotion"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.21.0")
  ],
  targets: [
    .target(
      name: "ComposableCoreMotion",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "ComposableCoreMotionTests",
      dependencies: ["ComposableCoreMotion"]
    ),
  ]
)
