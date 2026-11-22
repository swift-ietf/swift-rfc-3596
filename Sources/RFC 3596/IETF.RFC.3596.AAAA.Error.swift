public import RFC_4291

extension IETF.RFC.`3596`.AAAA {
    /// Errors that can occur when parsing AAAA records
    public enum Error: Swift.Error, Sendable, Equatable {
        /// The byte sequence is not exactly 16 bytes
        case invalidLength(_ length: Int)

        /// The bytes could not be parsed as a valid IPv6 address
        case invalidAddress(_ underlying: IETF.RFC.`4291`.IPv6.Address.Error)
    }
}

extension IETF.RFC.`3596`.AAAA.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidLength(let length):
            return "AAAA record requires exactly 16 bytes, got \(length)"
        case .invalidAddress(let error):
            return "Invalid IPv6 address: \(error)"
        }
    }
}
