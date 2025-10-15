import CoreFoundation

/// A unique identifier that can be used to identify objects.
public struct UniqueID: Sendable, Hashable, Equatable, Identifiable, CustomStringConvertible {
    public var id: Self { get { self } }
    private var hi: UInt64
    private var lo: UInt64

    /// Create a new unique identifier.
    /// - Parameters:
    ///   - hi: The high 64 bits of the identifier.
    ///   - lo: The low 64 bits of the identifier.
    private init(hi: UInt64, lo: UInt64) {
        self.hi = hi
        self.lo = lo
    }

    /// Generate a new unique identifier.
    /// - Returns: A new unique identifier.
    public static func generate() -> UniqueID {
        .init(
            hi: UInt64(bitPattern: Int64.random(in: Int64.min...Int64.max)),
            lo: UInt64(bitPattern: Int64.random(in: Int64.min...Int64.max))
        )
    }

    public var description: String {
        func toHex(_ value: UInt64) -> String {
            if value == 0 { return "0000000000000000" }
            let digits: [Character] = Array("0123456789ABCDEF")
            var out = String()
            out.reserveCapacity(16)

            // Emit all 16 nibbles (MSB first)
            for shift in stride(from: 60, through: 0, by: -4) {
                let nibble = Int((value >> UInt64(shift)) & 0xF)
                out.append(digits[nibble])
            }
            return out
        }
        return "\(toHex(hi))-\(toHex(lo))"
    }
}
