import Foundation
import SwiftUI

struct PrompterSettings: Equatable {
    var speed: Double = 28
    var fontSize: Double = 36
    var lineSpacing: Double = 8
    var isMirrored: Bool = false
    var countdownSeconds: Int = 3
    var textColor: ColorOption = .warmWhite
    var backgroundColor: ColorOption = .ink

    enum ColorOption: String, CaseIterable, Identifiable {
        case warmWhite
        case softYellow
        case mint
        case ink
        case charcoal
        case pureBlack

        var id: String { rawValue }

        var label: String {
            switch self {
            case .warmWhite: return "Warm White"
            case .softYellow: return "Soft Yellow"
            case .mint: return "Mint"
            case .ink: return "Ink"
            case .charcoal: return "Charcoal"
            case .pureBlack: return "Black"
            }
        }

        var color: Color {
            switch self {
            case .warmWhite: return Color(red: 0.96, green: 0.95, blue: 0.90)
            case .softYellow: return Color(red: 1.0, green: 0.92, blue: 0.55)
            case .mint: return Color(red: 0.72, green: 0.95, blue: 0.86)
            case .ink: return Color(red: 0.07, green: 0.08, blue: 0.10)
            case .charcoal: return Color(red: 0.14, green: 0.15, blue: 0.17)
            case .pureBlack: return .black
            }
        }
    }
}
