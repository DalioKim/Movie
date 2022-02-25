

import Foundation

// MARK: - Set DateStyle

extension DateFormatter {
    func setStyle() -> DateFormatter {
        self.dateStyle = .medium
        return self
    }
}

