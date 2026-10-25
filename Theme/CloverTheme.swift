import SwiftUI

enum CloverTheme {
    static let accent = Color(red: 0.43, green: 0.37, blue: 0.98)
    static let secondaryAccent = Color(red: 0.23, green: 0.66, blue: 0.98)
    static let background = Color(uiColor: .systemGroupedBackground)
    static let card = Color(uiColor: .secondarySystemGroupedBackground)

    static let gradient = LinearGradient(
        colors: [accent, secondaryAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
