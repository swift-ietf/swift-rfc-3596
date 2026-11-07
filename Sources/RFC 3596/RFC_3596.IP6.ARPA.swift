import RFC_1035
public import RFC_4291

extension RFC_3596 {
    /// IP6.ARPA domain namespace
    ///
    /// Per RFC 3596 Section 2.5, the IP6.ARPA domain is used for
    /// reverse DNS lookups of IPv6 addresses.
    ///
    /// The format uses nibbles (4-bit values) in reverse order, separated
    /// by dots, followed by "ip6.arpa".
    public enum IP6 {
        public enum ARPA {}
    }
}

extension RFC_3596.IP6.ARPA {
    /// The suffix for IPv6 reverse DNS names
    public static let suffix = "ip6.arpa"

    /// Generates the reverse DNS domain name for an IPv6 address
    ///
    /// Per RFC 3596 Section 2.5, the reverse lookup domain is formed by
    /// reversing the nibbles of the address and appending "ip6.arpa".
    ///
    /// Note: Returns a String rather than RFC_1035.Domain because ip6.arpa
    /// labels are hex nibbles which don't conform to RFC 1035 label syntax
    /// (which requires labels to start with a letter).
    ///
    /// ## Example
    ///
    /// For address `2001:db8::1`:
    /// ```
    /// 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa
    /// ```
    ///
    /// - Parameter address: The IPv6 address
    /// - Returns: The reverse DNS domain name as a String
    public static func domain(for address: RFC_4291.IPv6.Address) -> String {
        let segments = [
            address.segments.0, address.segments.1,
            address.segments.2, address.segments.3,
            address.segments.4, address.segments.5,
            address.segments.6, address.segments.7,
        ]

        var nibbles: [Character] = []
        nibbles.reserveCapacity(32)

        for segment in segments.reversed() {
            for shift in [0, 4, 8, 12] {
                let nibble = (segment >> shift) & 0xF
                let char = Character(String(nibble, radix: 16, uppercase: false))
                nibbles.append(char)
            }
        }

        return nibbles.map(String.init).joined(separator: ".") + "." + suffix
    }
}
