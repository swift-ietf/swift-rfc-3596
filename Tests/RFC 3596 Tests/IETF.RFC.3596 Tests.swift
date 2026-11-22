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

import Byte
import Testing
@testable import RFC_3596

enum `IETF.RFC.3596 Tests` {}

extension `IETF.RFC.3596 Tests` {
    @Suite
    struct `RFC 3596 DNS AAAA Record Tests` {

        @Suite
        struct IP6ARPATests {
            @Test
            func `Generate reverse DNS domain`() {
                // 2001:db8::1
                let address = IETF.RFC.`4291`.IPv6.Address(0x2001, 0x0db8, 0, 0, 0, 0, 0, 1)
                let domain = IETF.RFC.`3596`.IP6.ARPA.domain(for: address)

                // Expected: 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa
                let expected = "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa"
                #expect(domain == expected)
            }

            @Test
            func `Loopback reverse DNS`() {
                let domain = IETF.RFC.`3596`.IP6.ARPA.domain(for: .loopback)

                // ::1 = all zeros except last nibble is 1
                let expected = "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa"
                #expect(domain == expected)
            }

            @Test
            func `Suffix is ip6.arpa`() {
                #expect(IETF.RFC.`3596`.IP6.ARPA.suffix == "ip6.arpa")
            }
        }
    }
}

extension `IETF.RFC.3596 Tests`.`RFC 3596 DNS AAAA Record Tests` {
    @Suite
    struct `Record Type Tests` {
        @Test
        func `Record type is 28`() {
            #expect(IETF.RFC.`3596`.recordType == 28)
        }

        @Test
        func `Record type name is AAAA`() {
            #expect(IETF.RFC.`3596`.recordTypeName == "AAAA")
        }
    }

    @Suite
    struct `AAAA Record Tests` {
        @Test
        func `Create from IPv6 address`() {
            let address = IETF.RFC.`4291`.IPv6.Address(0x2001, 0xdb8, 0, 0, 0, 0, 0, 1)
            let record = IETF.RFC.`3596`.AAAA(address: address)

            #expect(record.address == address)
        }

        @Test
        func `Serialize to 16 bytes`() {
            let address = IETF.RFC.`4291`.IPv6.Address(0x2001, 0x0db8, 0, 0, 0, 0, 0, 1)
            let record = IETF.RFC.`3596`.AAAA(address: address)

            var buffer: [Byte] = []
            IETF.RFC.`3596`.AAAA.serialize(record, into: &buffer)

            #expect(buffer.count == 16)
            // First segment: 0x2001
            #expect(buffer[0] == Byte(0x20))
            #expect(buffer[1] == Byte(0x01))
            // Second segment: 0x0db8
            #expect(buffer[2] == Byte(0x0d))
            #expect(buffer[3] == Byte(0xb8))
            // Last byte: 0x01
            #expect(buffer[15] == Byte(0x01))
        }

        @Test
        func `Parse from 16 bytes`() throws {
            let bytes: [Byte] = [
                Byte(0x20), Byte(0x01), Byte(0x0d), Byte(0xb8), Byte(0x00), Byte(0x00), Byte(0x00), Byte(0x00),
                Byte(0x00), Byte(0x00), Byte(0x00), Byte(0x00), Byte(0x00), Byte(0x00), Byte(0x00), Byte(0x01),
            ]

            let record = try IETF.RFC.`3596`.AAAA(binary: bytes)

            #expect(record.address.segments.0 == 0x2001)
            #expect(record.address.segments.1 == 0x0db8)
            #expect(record.address.segments.7 == 0x0001)
        }

        @Test
        func `Reject invalid length`() {
            let shortBytes: [Byte] = [Byte(0x20), Byte(0x01), Byte(0x0d), Byte(0xb8)]

            #expect(throws: IETF.RFC.`3596`.AAAA.Error.self) {
                try IETF.RFC.`3596`.AAAA(binary: shortBytes)
            }
        }

        @Test
        func `Serialization round-trip`() throws {
            let original = IETF.RFC.`3596`.AAAA(
                address: IETF.RFC.`4291`.IPv6.Address(0xfe80, 0, 0, 0, 0, 0, 0, 1)
            )

            var buffer: [Byte] = []
            IETF.RFC.`3596`.AAAA.serialize(original, into: &buffer)

            let parsed = try IETF.RFC.`3596`.AAAA(binary: buffer)

            #expect(parsed.address == original.address)
        }

        @Test
        func `Description is IPv6 address string`() throws {
            let record = IETF.RFC.`3596`.AAAA(
                address: try IETF.RFC.`4291`.IPv6.Address(ascii: [Byte](utf8: "2001:db8::1"))
            )

            #expect(record.description == "2001:db8::1")
        }
    }
}
