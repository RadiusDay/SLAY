import CoreFoundation

/// A color representation supporting multiple color spaces and conversions between them.
public enum Color: Sendable, Hashable, Equatable {
    /// A color in the Oklab color space.
    public struct Oklab: Sendable, Hashable, Equatable {
        /// The lightness component (0 to 1).
        public var l: Double
        /// The a component (0 to 1).
        public var a: Double
        /// The b component (0 to 1).
        public var b: Double
        /// The alpha (opacity) component (0 to 1).
        public var alpha: Double = 1.0

        /// Creates a new Oklab color.
        /// - Parameters:
        ///   - l: The lightness component (0 to 1).
        ///   - a: The a component (0 to 1).
        ///   - b: The b component (0 to 1).
        ///   - alpha: The alpha (opacity) component (0 to 1).
        public init(l: Double, a: Double, b: Double, alpha: Double = 1.0) {
            self.l = l
            self.a = a
            self.b = b
            self.alpha = alpha
        }

        /// Converts the color to the Oklch color space.
        /// - Returns: The color in the Oklch color space.
        public func toOklch() -> Oklch {
            let c = sqrt(a * a + b * b)
            let hr = atan2(b, a)
            var h = hr * (180.0 / .pi)
            if h < 0 {
                h += 360.0
            }
            return .init(
                l: l,
                c: c,
                h: h,
                alpha: alpha
            )
        }

        /// Converts the color to the linear RGB color space.
        /// - Returns: The color in the linear RGB color space.
        public func toLinearRgb() -> LinearRgb {
            let l_ = l + 0.3963377774 * a + 0.2158037573 * b
            let m_ = l - 0.1055613458 * a - 0.0638541728 * b
            let s_ = l - 0.0894841775 * a - 1.2914855480 * b

            let l = l_ * l_ * l_
            let m = m_ * m_ * m_
            let s = s_ * s_ * s_

            return .init(
                r: (+4.0767416621 * l) + (-3.3077115913 * m) + (0.2309699292 * s),
                g: (-1.2684380046 * l) + (2.6097574011 * m) + (-0.3413193965 * s),
                b: (-0.0041960863 * l) + (-0.7034186147 * m) + (1.7076147010 * s),
                alpha: alpha
            )
        }
    }

    /// A color in the Oklch color space.
    ///
    /// Like Oklab, but with cylindrical coordinates.
    public struct Oklch: Sendable, Hashable, Equatable {
        /// The lightness component (0 to 1).
        public var l: Double
        /// The chroma component (0 to 1).
        public var c: Double
        /// The hue component (0 to 360).
        public var h: Double
        /// The alpha (opacity) component (0 to 1).
        public var alpha: Double = 1.0

        /// Creates a new Oklch color.
        /// - Parameters:
        ///   - l: The lightness component (0 to 1).
        ///   - c: The chroma component (0 to 1).
        ///   - h: The hue component (0 to 360).
        ///   - alpha: The alpha (opacity) component (0 to 1).
        public init(l: Double, c: Double, h: Double, alpha: Double = 1.0) {
            self.l = l
            self.c = c
            self.h = h
            self.alpha = alpha
        }

        /// Converts the color to the Oklab color space.
        /// - Returns: The color in the Oklab color space.
        public func toOklab() -> Oklab {
            let hr = h * (.pi / 180.0)
            return .init(
                l: l,
                a: c * cos(hr),
                b: c * sin(hr),
                alpha: alpha
            )
        }
    }

    /// A color in the linear RGB color space.
    ///
    /// Linear RGB is a color space where the RGB components are linear with respect to human perception.
    /// This is different from standard RGB, which is gamma-corrected.
    public struct LinearRgb: Sendable, Hashable, Equatable {
        /// The red component (0 to 1).
        public var r: Double
        /// The green component (0 to 1).
        public var g: Double
        /// The blue component (0 to 1).
        public var b: Double
        /// The alpha (opacity) component (0 to 1).
        public var alpha: Double = 1.0

        /// Creates a new LinearRgb color.
        /// - Parameters:
        ///   - r: The red component (0 to 1).
        ///   - g: The green component (0 to 1).
        ///   - b: The blue component (0 to 1).
        ///   - alpha: The alpha (opacity) component (0 to 1).
        public init(r: Double, g: Double, b: Double, alpha: Double = 1.0) {
            self.r = r
            self.g = g
            self.b = b
            self.alpha = alpha
        }

        /// Converts the color to the Oklab color space.
        /// - Returns: The color in the Oklab color space.
        public func toOklab() -> Oklab {
            let l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b
            let m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b
            let s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b

            let l_ = cbrt(l)
            let m_ = cbrt(m)
            let s_ = cbrt(s)

            return .init(
                l: (0.2104542553 * l_) + (0.7936177850 * m_) + (-0.0040720468 * s_),
                a: (1.9779984951 * l_) + (-2.4285922050 * m_) + (0.4505937099 * s_),
                b: (0.0259040371 * l_) + (0.7827717662 * m_) + (-0.8086757660 * s_),
                alpha: alpha
            )
        }

        /// Converts the color to the standard RGB color space.
        /// - Returns: The color in the standard RGB color space.
        public func toRgb() -> Rgb {
            func f(_ x: Double) -> Double {
                if x >= 0.0031308 {
                    return 1.055 * pow(x, 1.0 / 2.4) - 0.055
                }
                return 12.92 * x
            }
            return .init(
                r: f(r),
                g: f(g),
                b: f(b),
                alpha: alpha
            )
        }
    }

    /// A color in the standard RGB color space.
    ///
    /// Standard RGB is a color space commonly used in digital displays and images.
    /// It is gamma-corrected to better match human perception.
    public struct Rgb: Sendable, Hashable, Equatable {
        /// The red component (0 to 1).
        public var r: Double
        /// The green component (0 to 1).
        public var g: Double
        /// The blue component (0 to 1).
        public var b: Double
        /// The alpha (opacity) component (0 to 1).
        public var alpha: Double = 1.0

        /// Creates a new Rgb color.
        /// - Parameters:
        ///   - r: The red component (0 to 1).
        ///   - g: The green component (0 to 1).
        ///   - b: The blue component (0 to 1).
        ///   - alpha: The alpha (opacity) component (0 to 1).
        public init(r: Double, g: Double, b: Double, alpha: Double = 1.0) {
            self.r = r
            self.g = g
            self.b = b
            self.alpha = alpha
        }

        /// Converts the color to the linear RGB color space.
        /// - Returns: The color in the linear RGB color space.
        public func toLinearRgb() -> LinearRgb {
            func f(_ x: Double) -> Double {
                if x >= 0.04045 {
                    return pow((x + 0.055) / 1.055, 2.4)
                }
                return x / 12.92
            }
            return .init(
                r: f(r),
                g: f(g),
                b: f(b),
                alpha: alpha
            )
        }
    }

    /// A color in the HSL (Hue, Saturation, Lightness) color space.
    ///
    /// HSL is a cylindrical-coordinate representation of colors.
    /// It is often used in color pickers and design tools.
    public struct Hsl: Sendable, Hashable, Equatable {
        /// The hue component (0 to 360).
        public var h: Double
        /// The saturation component (0 to 1).
        public var s: Double
        /// The lightness component (0 to 1).
        public var l: Double
        /// The alpha (opacity) component (0 to 1).
        public var alpha: Double = 1.0

        /// Creates a new Hsl color.
        /// - Parameters:
        ///   - h: The hue component (0 to 360).
        ///   - s: The saturation component (0 to 1).
        ///   - l: The lightness component (0 to 1).
        ///   - alpha: The alpha (opacity) component (0 to 1).
        public init(h: Double, s: Double, l: Double, alpha: Double = 1.0) {
            self.h = h
            self.s = s
            self.l = l
            self.alpha = alpha
        }

        /// Converts the color to the RGB color space.
        /// - Returns: The color in the RGB color space.
        private func hueToRgb(p: Double, q: Double, t: Double) -> Double {
            var t = t
            if t < 0 { t += 1 }
            if t > 1 { t -= 1 }
            if t < 1 / 6 { return p + (q - p) * 6 * t }
            if t < 1 / 2 { return q }
            if t < 2 / 3 { return p + (q - p) * (2 / 3 - t) * 6 }
            return p
        }

        /// Converts the color to the RGB color space.
        /// - Returns: The color in the RGB color space.
        public func toRgb() -> Rgb {
            let h = self.h / 360.0
            let s = self.s
            let l = self.l

            if s == 0 {
                return .init(r: l, g: l, b: l, alpha: alpha)  // achromatic
            } else {
                let q = l < 0.5 ? l * (1 + s) : l + s - l * s
                let p = 2 * l - q
                let r = hueToRgb(p: p, q: q, t: h + 1 / 3)
                let g = hueToRgb(p: p, q: q, t: h)
                let b = hueToRgb(p: p, q: q, t: h - 1 / 3)
                return .init(r: r, g: g, b: b, alpha: alpha)
            }
        }
    }

    case oklab(Oklab)
    case oklch(Oklch)
    case linearRgb(LinearRgb)
    case rgb(Rgb)
    case hsl(Hsl)

    /// Creates a new Color instance from various color space components.
    /// - Parameters:
    ///   - l: The lightness component (0 to 1).
    ///   - a: The a component (0 to 1).
    ///   - b: The b component (0 to 1).
    ///   - alpha: The alpha (opacity) component (0 to 1).
    public init(l: Double, a: Double, b: Double, alpha: Double = 1.0) {
        self = .oklab(Oklab(l: l, a: a, b: b, alpha: alpha))
    }

    /// Creates a new Color instance from various color space components.
    /// - Parameters:
    ///   - l: The lightness component (0 to 1).
    ///   - c: The chroma component (0 to 1).
    ///   - h: The hue component (0 to 360).
    ///   - alpha: The alpha (opacity) component (0 to 1).
    public init(l: Double, c: Double, h: Double, alpha: Double = 1.0) {
        self = .oklch(Oklch(l: l, c: c, h: h, alpha: alpha))
    }

    /// Creates a new Color instance from various color space components.
    /// - Parameters:
    ///   - r: The red component (0 to 1).
    ///   - g: The green component (0 to 1).
    ///   - b: The blue component (0 to 1).
    ///   - alpha: The alpha (opacity) component (0 to 1).
    public init(r: Double, g: Double, b: Double, alpha: Double = 1.0) {
        self = .rgb(Rgb(r: r, g: g, b: b, alpha: alpha))
    }

    /// Creates a new Color instance from various color space components.
    /// - Parameters:
    ///   - r: The red component (0 to 1).
    ///   - g: The green component (0 to 1).
    ///   - b: The blue component (0 to 1).
    ///   - alpha: The alpha (opacity) component (0 to 1).
    public init(h: Double, s: Double, l: Double, alpha: Double = 1.0) {
        self = .hsl(Hsl(h: h, s: s, l: l, alpha: alpha))
    }

    /// A predefined white color.
    public static let white = Color(l: 1, a: 0, b: 0, alpha: 1.0)

    /// A predefined black color.
    public static let black = Color(l: 0, a: 0, b: 0, alpha: 1.0)

    /// A predefined clear (transparent) color.
    public static let clear = Color(r: 0, g: 0, b: 0, alpha: 0.0)

    public var alpha: Double {
        switch self {
        case .oklab(let color):
            return color.alpha
        case .oklch(let color):
            return color.alpha
        case .linearRgb(let color):
            return color.alpha
        case .rgb(let color):
            return color.alpha
        case .hsl(let color):
            return color.alpha
        }
    }
}
