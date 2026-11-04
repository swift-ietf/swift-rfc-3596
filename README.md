# swift-rfc-3596

Use this package when you encode or decode the RDATA of a DNS AAAA record, or need the ip6.arpa name for a reverse lookup of an IPv6 address. Start from `RFC_3596.AAAA` for records and `RFC_3596.IP6.ARPA` for reverse names. To resolve names rather than handle record bytes, use swift-domain-name-system. For the address type itself, use swift-rfc-4291.

## Laws

- AAAA RDATA is exactly 16 bytes, the address in network byte order. Any other length fails.
- A record prints as its address in RFC 5952 canonical text, such as `2001:db8::1`.
- `RFC_3596.IP6.ARPA.domain(for:)` writes all 32 nibbles of the address, least significant first, as lowercase hex digits separated by dots, then `ip6.arpa`. Zero nibbles are written out, and there is no trailing dot.
