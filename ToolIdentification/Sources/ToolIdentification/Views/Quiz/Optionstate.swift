//
//  OptionState.swift
//
//
//  Created by Krati Mittal on 15/02/24.
//

import Foundation
import SwiftUI

enum Optionstate {
case none
case correct
case incorrect

var color: Color {
    switch self {
    case .none:
        Color(red: 0.26, green: 0.26, blue: 0.25)
    case .correct:
        Color(red: 0.37, green: 0.81, blue: 0.49)
    case .incorrect:
        Color(red: 0.86, green: 0.39, blue: 0.31)
    }
}

var image: String {
    switch self {
    case .correct: "TickMarkIcon"
    case .incorrect: "CrossMarkIcon"
    case .none: ""
    }
}
}
