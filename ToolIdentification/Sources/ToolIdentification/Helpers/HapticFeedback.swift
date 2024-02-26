//
//  HapticFeedback.swift
//  BaseOklahoma
//
//  Created by Akanksha Trivedi on 10/02/23.
//  Copyright © 2023 Nickelfox. All rights reserved.
//

import UIKit

enum ImpactIntensity {
    case defaultIntensity
    case heavy
    case light
    case medium
    case rigid
    case soft
}

class HapticFeedback {
    
    static let shared = HapticFeedback()
    
    private init () {
    }
    
    private static var selectionFeedback: UISelectionFeedbackGenerator {
        return UISelectionFeedbackGenerator()
    }
    
    private static var notificationFeedback: UINotificationFeedbackGenerator {
        return UINotificationFeedbackGenerator()
    }
    
    static func impact(intensity: ImpactIntensity = .defaultIntensity) {
        switch intensity {
        case .defaultIntensity:
            UIImpactFeedbackGenerator().impactOccurred(intensity: 5)
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .rigid:
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        case .soft:
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
    }
    
    static func success() {
        self.notificationFeedback.notificationOccurred(.success)
    }
    
    static func warning() {
        self.notificationFeedback.notificationOccurred(.warning)
    }
    
    static func error() {
        self.notificationFeedback.notificationOccurred(.error)
    }
}
