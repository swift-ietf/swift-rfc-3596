// swift-tools-version: 6.2

import PackageDescription

extension String {
    static let rfc3596: Self = "RFC 3596"
}

extension Target.Dependency {
    static var rfc3596: Self { .target(name: .rfc3596) }
    static var rfc1035: Self { .product(name: "RFC 1035", package: "swift-rfc-1035") }
    static var rfc4291: Self { .product(name: "RFC 4291", package: "swift-rfc-4291") }
    static var standards: Self { .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions") }
}

let package = Package(
    name: "swift-rfc-3596",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(name: "RFC 3596", targets: ["RFC 3596"])
    ],
    dependencies: [
        .package(path: "../swift-rfc-1035"),
        .package(path: "../swift-rfc-4291"),
        .package(path: "../../swift-primitives/swift-standard-library-extensions")
    ],
    targets: [
        .target(
            name: "RFC 3596",
            dependencies: [
                .rfc1035,
                .rfc4291,
                .standards
            ]
        ),
        .testTarget(
            name: "RFC 3596 Tests",
            dependencies: [
                "RFC 3596",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
