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

// RFC_3596.AAAA.swift
// swift-rfc-3596
//
// RFC 3596 Section 2.1: AAAA Record Format

public import RFC_4291

extension RFC_3596 {
    /// AAAA Resource Record for IPv6 addresses
    ///
    /// Per RFC 3596 Section 2.1, the AAAA resource record stores a single
    /// IPv6 address. The address is stored as 16 octets in network byte order.
    ///
    /// ## Wire Format
    ///
    /// The RDATA section contains a 128-bit IPv6 address encoded in network
    /// byte order (big-endian). The RDLENGTH is always 16.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Create from IPv6 address
    /// let address = RFC_4291.IPv6.Address(0x2001, 0xdb8, 0, 0, 0, 0, 0, 1)
    /// let record = RFC_3596.AAAA(address: address)
    ///
    /// // Serialize to bytes
    /// var buffer: [UInt8] = []
    /// RFC_3596.AAAA.serialize(record, into: &buffer)
    /// // buffer = [0x20, 0x01, 0x0d, 0xb8, 0x00, 0x00, 0x00, 0x00,
    /// //           0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]
    /// ```
    public struct AAAA: Sendable, Hashable, Codable {
        /// The IPv6 address
        public let address: RFC_4291.IPv6.Address

        /// Creates an AAAA record from an IPv6 address
        ///
        /// - Parameter address: The IPv6 address to store
        public init(address: RFC_4291.IPv6.Address) {
            self.address = address
        }
    }
}

// MARK: - Binary.Serializable

extension RFC_3596.AAAA: Binary.Serializable {
    /// Serializes the AAAA record to wire format
    ///
    /// The IPv6 address is written as 16 octets in network byte order.
    ///
    /// - Parameters:
    ///   - record: The AAAA record to serialize
    ///   - buffer: The buffer to append bytes to
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ record: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        // Delegate to RFC 4291 binary serialization (16 bytes, network order)
        RFC_4291.IPv6.Address.serialize(record.address, into: &buffer)
    }

    /// Parses an AAAA record from wire format bytes
    ///
    /// - Parameter bytes: Exactly 16 bytes in network byte order
    /// - Throws: `Error.invalidLength` if not exactly 16 bytes
    public init<Bytes: Collection>(binary bytes: Bytes) throws(Error)
    where Bytes.Element == UInt8 {
        guard bytes.count == 16 else {
            throw Error.invalidLength(bytes.count)
        }
        do {
            let address = try RFC_4291.IPv6.Address(binary: bytes)
            self.init(address: address)
        } catch {
            throw Error.invalidAddress(error)
        }
    }
}

// MARK: - CustomStringConvertible

extension RFC_3596.AAAA: CustomStringConvertible {
    public var description: String {
        address.description
    }
}
