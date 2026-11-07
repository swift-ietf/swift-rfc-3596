/// RFC 3596: DNS Extensions to Support IP Version 6
///
/// This namespace contains types for DNS support of IPv6 addresses
/// as defined in RFC 3596 from October 2003.
///
/// RFC 3596 defines:
/// - AAAA resource record type for IPv6 addresses
/// - IP6.ARPA domain for reverse lookups
///
/// ## Key Types
///
/// - ``AAAA``: Resource record containing an IPv6 address
///
/// ## Example
///
/// ```swift
/// // Create an AAAA record
/// let address = RFC_4291.IPv6.Address(0x2001, 0xdb8, 0, 0, 0, 0, 0, 1)
/// let record = RFC_3596.AAAA(address: address)
///
/// // Serialize to wire format
/// var buffer: [UInt8] = []
/// RFC_3596.AAAA.serialize(record, into: &buffer)
/// // buffer contains 16 bytes of the IPv6 address
/// ```
///
/// ## See Also
///
/// - [RFC 3596](https://www.rfc-editor.org/rfc/rfc3596)
/// - ``RFC_4291`` for IPv6 address format
/// - ``RFC_1035`` for DNS message format
public enum RFC_3596 {}

extension RFC_3596 {
    /// DNS record type value for AAAA records
    ///
    /// Per RFC 3596 Section 2.1, the AAAA resource record type is 28.
    public static let recordType: UInt16 = 28

    /// DNS record type name
    public static let recordTypeName = "AAAA"
}
