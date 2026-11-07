public import Binary
public import Byte
import ASCII
public import RFC_4291
import RFC_5952

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
    /// var buffer: [Byte] = []
    /// RFC_3596.AAAA.serialize(record, into: &buffer)
    /// // buffer = [0x20, 0x01, 0x0d, 0xb8, 0x00, 0x00, 0x00, 0x00,
    /// //           0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]
    /// ```
    public struct AAAA: Sendable, Hashable {
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
    ) where Buffer.Element == Byte {
        RFC_4291.IPv6.Address.serialize(record.address, into: &buffer)
    }

    /// Parses an AAAA record from wire format bytes
    ///
    /// - Parameter bytes: Exactly 16 bytes in network byte order
    /// - Throws: `Error.invalidLength` if not exactly 16 bytes
    public init<Bytes: Swift::Collection>(binary bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard bytes.count == 16 else {
            throw Error.invalidLength(bytes.count)
        }
        do throws(RFC_4291.IPv6.Address.Error) {
            let address = try RFC_4291.IPv6.Address(binary: bytes)
            self.init(address: address)
        } catch {
            throw Error.invalidAddress(error)
        }
    }
}

extension RFC_3596.AAAA: CustomStringConvertible {
    public var description: String {
        var codes: [ASCII.Code] = []
        RFC_4291.IPv6.Address.Text.Canonical().serialize(address, into: &codes)
        return String(decoding: codes.lazy.map(\.underlying), as: UTF8.self)
    }
}
