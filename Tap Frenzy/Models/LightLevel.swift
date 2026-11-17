//
//  LightLevel.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

// MARK: - Light It Up Levels

enum LightLevel: Int, CaseIterable {

    case beginner = 1
    case intermediate = 2
    case advanced = 3
    case expert = 4

    // MARK: - Card Count

    var cardCount: Int {

        switch self {

        case .beginner:
            return 3

        case .intermediate:
            return 4

        case .advanced:
            return 6

        case .expert:
            return 9
        }
    }

    // MARK: - Grid Columns

    var columnCount: Int {

        switch self {

        case .beginner:
            return 3

        case .intermediate:
            return 4

        case .advanced:
            return 3

        case .expert:
            return 3
        }
    }

    // MARK: - Lit Duration

    var litDuration: TimeInterval {

        switch self {

        case .beginner:
            return 1.5

        case .intermediate:
            return 1.2

        case .advanced:
            return 1.0

        case .expert:
            return 0.8
        }
    }

    // MARK: - Level Name

    var title: String {

        switch self {

        case .beginner:
            return "BEGINNER"

        case .intermediate:
            return "INTERMEDIATE"

        case .advanced:
            return "ADVANCED"

        case .expert:
            return "EXPERT"
        }
    }

    // MARK: - Level Colour

    var color: Color {

        switch self {

        case .beginner:
            return .green

        case .intermediate:
            return .cyan

        case .advanced:
            return .orange

        case .expert:
            return .pink
        }
    }

    // MARK: - Simultaneous Cards

    var simultaneousCardCount: Int {

        switch self {

        case .beginner, .intermediate, .advanced:
            return 1

        case .expert:
            return 2
        }
    }
}
