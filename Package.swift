// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "composable-core-motion",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "ComposableCoreMotion",
      targets: ["ComposableCoreMotion"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .branch("extract-libraries"))
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
