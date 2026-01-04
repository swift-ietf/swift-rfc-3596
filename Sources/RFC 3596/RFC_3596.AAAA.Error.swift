// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of project contributors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

// RFC_3596.AAAA.Error.swift
// swift-rfc-3596

public import RFC_4291

extension RFC_3596.AAAA {
    /// Errors that can occur when parsing AAAA records
    public enum Error: Swift.Error, Sendable, Equatable {
        /// The byte sequence is not exactly 16 bytes
        case invalidLength(_ length: Int)

        /// The bytes could not be parsed as a valid IPv6 address
        case invalidAddress(_ underlying: RFC_4291.IPv6.Address.Error)
    }
}

extension RFC_3596.AAAA.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidLength(let length):
            return "AAAA record requires exactly 16 bytes, got \(length)"
        case .invalidAddress(let error):
            return "Invalid IPv6 address: \(error)"
        }
    }
}
