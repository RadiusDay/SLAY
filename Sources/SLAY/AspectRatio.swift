/// Aspect ratio utilities.
public enum AspectRatio {
    public static func solve(
        _ ratio: Double,
        width: Double?,
        height: Double?,
        minWidth: Double = 0,
        minHeight: Double = 0,
        maxWidth: Double = .infinity,
        maxHeight: Double = .infinity
    ) -> Vector2 {
        // What axis we need to solve for
        let axis =
            switch (width, height) {
            case (.some, .none): Axis.vertical
            case (.none, .some): Axis.horizontal
            case (.none, .none): Axis.horizontal
            case (.some(let w), .some(let h)):
                // Choose the largest axis to solve for
                if w / ratio > h {
                    Axis.vertical
                } else {
                    Axis.horizontal
                }
            }
        let majorSize =
            switch axis {
            case .horizontal: height ?? 0
            case .vertical: width ?? 0
            }
        if majorSize <= 0 {
            return Vector2(
                x: max(minWidth, min(maxWidth, 0)),
                y: max(minHeight, min(maxHeight, 0))
            )
        }

        // .horizontal = (solve for, given)
        // .vertical = (given, solve for)
        let idealCase =
            switch axis {
            case .horizontal: majorSize * ratio
            case .vertical: majorSize / ratio
            }

        let idealResult =
            switch axis {
            case .horizontal: Vector2(x: idealCase, y: majorSize)
            case .vertical: Vector2(x: majorSize, y: idealCase)
            }
        if minWidth <= idealResult.x && minHeight <= idealResult.y && maxWidth >= idealResult.x
            && maxHeight >= idealResult.y
        {
            // Ideal case is possible
            return idealResult
        }

        // In this case, the ideal case is not possible
        // We should solve for as close to the ideal case as possible
        var candidates: [(Vector2, Double)] = [
            // Min width
            (Vector2(x: minWidth, y: minWidth / ratio), minWidth * (minWidth / ratio)),
            // Max width
            (Vector2(x: maxWidth, y: maxWidth / ratio), maxWidth * (maxWidth / ratio)),
            // Min height
            (Vector2(x: minHeight * ratio, y: minHeight), minHeight * (minHeight * ratio)),
            // Max height
            (Vector2(x: maxHeight * ratio, y: maxHeight), maxHeight * (maxHeight * ratio)),
        ]
        candidates = candidates.filter { (candidate, area) in
            return candidate.x >= minWidth && candidate.x <= maxWidth && candidate.y >= minHeight
                && candidate.y <= maxHeight && candidate.x.isFinite && candidate.y.isFinite
                && area.isFinite
        }
        if candidates.isEmpty {
            // Break the aspect ratio
            return Vector2(
                x: max(minWidth, min(majorSize, idealResult.x)),
                y: max(minHeight, min(majorSize, idealResult.y))
            )
        }

        candidates.sort { $0.1 > $1.1 }
        return candidates.first!.0
    }
}
