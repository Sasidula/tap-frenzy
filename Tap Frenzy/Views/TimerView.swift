//
//  ScoreCard.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct TimerView: View {

    @ObservedObject var game: GameManager

    private let pink = Color(
        red: 1.0,
        green: 0.12,
        blue: 0.55
    )

    private var timerColor: Color {
        game.timeRemaining <= 5 ? pink : .white
    }

    var body: some View {

        VStack(spacing: 12) {

            Text("\(game.timeRemaining)")
                .font(.system(
                    size: 55,
                    weight: .black,
                    design: .rounded
                ))
                .foregroundColor(timerColor)
                .contentTransition(.numericText())
                .shadow(
                    color: timerColor.opacity(0.6),
                    radius: 12
                )

            Text("SECONDS REMAINING")
                .font(.system(size: 10, weight: .bold))
                .tracking(3)
                .foregroundColor(.white.opacity(0.5))

            ProgressView(
                value: Double(game.timeRemaining),
                total: Double(game.selectedDuration)
            )
            .tint(timerColor)
            .scaleEffect(x: 1, y: 1.5)
            .padding(.horizontal, 25)
        }
        .padding(.vertical, 10)
    }
}
