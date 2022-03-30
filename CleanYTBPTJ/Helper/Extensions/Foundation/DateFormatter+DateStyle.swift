
import Foundation

// MARK: - Set DateStyle convenience init

extension DateFormatter {
    convenience init(dateStyle: DateFormatter.Style) {
        self.init()
        self.dateStyle = dateStyle
    }
}
