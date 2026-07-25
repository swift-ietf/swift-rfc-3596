# swift-rfc-3596

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The AAAA resource record and IPv6 reverse-mapping domain of RFC 3596.

## Standard Reference

- **RFC**: 3596
- **Title**: DNS Extensions to Support IP Version 6

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-ietf/swift-rfc-3596.git", from: "0.0.1")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RFC 3596", package: "swift-rfc-3596")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
