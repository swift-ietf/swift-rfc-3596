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

import Testing
@testable import RFC_3596

@Suite("RFC 3596 DNS AAAA Record Tests")
struct RFC3596Tests {

    @Suite("Record Type Tests")
    struct RecordTypeTests {
        @Test
        func `Record type is 28`() {
            #expect(RFC_3596.recordType == 28)
        }

        @Test
        func `Record type name is AAAA`() {
            #expect(RFC_3596.recordTypeName == "AAAA")
        }
    }

    @Suite("AAAA Record Tests")
    struct AAAARecordTests {
        @Test
        func `Create from IPv6 address`() {
            let address = RFC_4291.IPv6.Address(0x2001, 0xdb8, 0, 0, 0, 0, 0, 1)
            let record = RFC_3596.AAAA(address: address)

            #expect(record.address == address)
        }

        @Test
        func `Serialize to 16 bytes`() {
            let address = RFC_4291.IPv6.Address(0x2001, 0x0db8, 0, 0, 0, 0, 0, 1)
            let record = RFC_3596.AAAA(address: address)

            var buffer: [Byte] = []
            RFC_3596.AAAA.serialize(record, into: &buffer)

            #expect(buffer.count == 16)
            // First segment: 0x2001
            #expect(buffer[0] == 0x20)
            #expect(buffer[1] == 0x01)
            // Second segment: 0x0db8
            #expect(buffer[2] == 0x0d)
            #expect(buffer[3] == 0xb8)
            // Last byte: 0x01
            #expect(buffer[15] == 0x01)
        }

        @Test
        func `Parse from 16 bytes`() throws {
            let bytes: [Byte] = [
                0x20, 0x01, 0x0d, 0xb8, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
            ]

            let record = try RFC_3596.AAAA(binary: bytes)

            #expect(record.address.segments.0 == 0x2001)
            #expect(record.address.segments.1 == 0x0db8)
            #expect(record.address.segments.7 == 0x0001)
        }

        @Test
        func `Reject invalid length`() {
            let shortBytes: [Byte] = [0x20, 0x01, 0x0d, 0xb8]

            #expect(throws: RFC_3596.AAAA.Error.self) {
                try RFC_3596.AAAA(binary: shortBytes)
            }
        }

        @Test
        func `Serialization round-trip`() throws {
            let original = RFC_3596.AAAA(
                address: RFC_4291.IPv6.Address(0xfe80, 0, 0, 0, 0, 0, 0, 1)
            )

            var buffer: [Byte] = []
            RFC_3596.AAAA.serialize(original, into: &buffer)

            let parsed = try RFC_3596.AAAA(binary: buffer)

            #expect(parsed.address == original.address)
        }

        @Test
        func `Description is IPv6 address string`() throws {
            let record = RFC_3596.AAAA(
                address: try RFC_4291.IPv6.Address(ascii: Array("2001:db8::1".utf8))
            )

            #expect(record.description == "2001:db8::1")
        }
    }

    @Suite("IP6.ARPA Tests")
    struct IP6ARPATests {
        @Test
        func `Generate reverse DNS domain`() {
            // 2001:db8::1
            let address = RFC_4291.IPv6.Address(0x2001, 0x0db8, 0, 0, 0, 0, 0, 1)
            let domain = RFC_3596.IP6.ARPA.domain(for: address)

            // Expected: 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa
            let expected = "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa"
            #expect(domain == expected)
        }

        @Test
        func `Loopback reverse DNS`() {
            let domain = RFC_3596.IP6.ARPA.domain(for: .loopback)

            // ::1 = all zeros except last nibble is 1
            let expected = "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa"
            #expect(domain == expected)
        }

        @Test
        func `Suffix is ip6.arpa`() {
            #expect(RFC_3596.IP6.ARPA.suffix == "ip6.arpa")
        }
    }
}
