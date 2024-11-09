// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Targets
let mainTarget = "TAPackage"
let networkingTarget = "TANetwork"
let placesListingFeatureTarget = "TAPlacesListingFeature"

// MARK: - Package
let package = Package(
    name: "TAPackage",
    defaultLocalization: "en-US",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: mainTarget,
            targets: [mainTarget]
        ),
        .library(
            name: networkingTarget,
            targets: [networkingTarget]
        ),
        .library(
            name: placesListingFeatureTarget,
            targets: [placesListingFeatureTarget]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: mainTarget),
        .testTarget(
            name: mainTarget.asTestTarget,
            dependencies: [
                mainTarget.asTargetDependency,
            ]
        ),
        .target(name: networkingTarget),
        .testTarget(
            name: networkingTarget.asTestTarget,
            dependencies: [
                networkingTarget.asTargetDependency,
            ]
        ),
        .target(
            name: placesListingFeatureTarget,
            dependencies: [
                networkingTarget.asTargetDependency,
            ]
        ),
        .testTarget(
            name: placesListingFeatureTarget.asTestTarget,
            dependencies: [
                placesListingFeatureTarget.asTargetDependency,
            ]
        ),
    ]
)

// MARK: - Helpers
extension String {
    var asTargetDependency: Target.Dependency {
        return Target.Dependency.target(name: self)
    }
    
    var asTestTarget: String {
        return "\(self)Tests"
    }
}
