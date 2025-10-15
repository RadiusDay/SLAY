import AppKit
import SLAYUI

extension Font {
    public var nsFont: NSFont {
        let fontName =
            self.fontName == "System"
            ? NSFont.systemFont(ofSize: CGFloat(pointSize)).fontName : self.fontName
        var descriptor = NSFontDescriptor(name: fontName, size: CGFloat(pointSize))

        var traits: NSFontDescriptor.SymbolicTraits = []
        if style == .italic {
            traits.insert(.italic)
        }
        descriptor = descriptor.withSymbolicTraits(traits)

        let normalized = ((weight - 400) / 500)
        let weightTrait = [NSFontDescriptor.TraitKey.weight: NSNumber(value: normalized)]
        descriptor = descriptor.addingAttributes([
            NSFontDescriptor.AttributeName.traits: weightTrait
        ])

        if let custom = NSFont(descriptor: descriptor, size: CGFloat(pointSize)) {
            return custom
        }

        // Fallback to system font if the custom font can't be created.
        return NSFont.systemFont(
            ofSize: CGFloat(pointSize),
            weight: NSFont.Weight(rawValue: CGFloat(normalized))
        )
    }
}
