import AppKit
import SLAYUI

extension Color {
    private func rgbToNsColor(rgb: Rgb) -> NSColor {
        return NSColor(
            calibratedRed: CGFloat(rgb.r),
            green: CGFloat(rgb.g),
            blue: CGFloat(rgb.b),
            alpha: CGFloat(rgb.alpha)
        )
    }

    public var nsColor: NSColor {
        switch self {
        case .oklab(let color):
            return rgbToNsColor(rgb: color.toLinearRgb().toRgb())
        case .oklch(let color):
            return rgbToNsColor(rgb: color.toOklab().toLinearRgb().toRgb())
        case .linearRgb(let color):
            return rgbToNsColor(rgb: color.toRgb())
        case .rgb(let color):
            return rgbToNsColor(rgb: color)
        case .hsl(let color):
            return rgbToNsColor(rgb: color.toRgb())
        }
    }
}
