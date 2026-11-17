//
//  ContentView.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct ContentView: View {

    // MARK: - Game Manager

    @StateObject private var game = GameManager()

    // MARK: - Colours

    private let pink = Color(
        red: 1.0,
        green: 0.12,
        blue: 0.55
    )

    // MARK: - Body

    var body: some View {

        ZStack {

            // Background
            Color.black
                .ignoresSafeArea()

            // Falling sparkles
            SparkleField()
                .ignoresSafeArea()

            VStack(spacing: 25) {

                // Game title
                gameTitle

                // Score cards
                HStack(spacing: 15) {

                    ScoreCard(
                        title: "SCORE",
                        value: game.score
                    )

                    ScoreCard(
                        title: "BEST",
                        value: game.bestScore
                    )
                }

                // Duration selector
                durationSelector

                // Timer
                TimerView(game: game)

                Spacer(minLength: 0)

                // Main tap button
                NeonTapButton {
                    game.handleTap()
                }
                .disabled(game.gamePhase == .over)

                // Game instruction
                Text(
                    game.gamePhase == .idle
                    ? "TAP TO START"
                    : game.gamePhase == .playing
                    ? "KEEP TAPPING!"
                    : "ROUND COMPLETED"
                )
                .font(.system(size: 11, weight: .bold))
                .tracking(3)
                .foregroundColor(.white.opacity(0.6))

                Spacer(minLength: 0)

                // Games played
                gamesPlayedSection
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 20)

            // Game over popup
            if game.gamePhase == .over {

                GameOverPopup(game: game)
            }
        }
    }

    // MARK: - Game Title

    private var gameTitle: some View {

        VStack(spacing: 5) {

            Text("TAP FRENZY")
                .font(.system(
                    size: 34,
                    weight: .black,
                    design: .rounded
                ))
                .foregroundColor(pink)
                .shadow(color: pink.opacity(0.8), radius: 15)

            Text("NEON CHALLENGE")
                .font(.system(
                    size: 11,
                    weight: .bold,
                    design: .monospaced
                ))
                .tracking(4)
                .foregroundColor(.white.opacity(0.6))
        }
    }

    // MARK: - Duration Selector

    private var durationSelector: some View {

        VStack(spacing: 10) {

            Text("ROUND DURATION")
                .font(.system(size: 11, weight: .bold))
                .tracking(2)
                .foregroundColor(.white.opacity(0.6))

            Picker(
                "Duration",
                selection: Binding(
                    get: {
                        game.selectedDuration
                    },
                    set: {
                        game.updateDuration($0)
                    }
                )
            ) {

                Text("5 Seconds").tag(5)
                Text("10 Seconds").tag(10)
                Text("20 Seconds").tag(20)
            }
            .pickerStyle(.menu)
            .tint(pink)
            .disabled(game.gamePhase != .idle)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .modifier(NeonGlassPanel())
        }
    }

    // MARK: - Games Played

    private var gamesPlayedSection: some View {

        HStack(spacing: 10) {

            Image(systemName: "gamecontroller.fill")
                .foregroundColor(pink)

            Text("GAMES PLAYED")
                .font(.system(size: 10, weight: .bold))
                .tracking(2)
                .foregroundColor(.white.opacity(0.6))

            Text("\(game.gamesPlayed)")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .contentTransition(.numericText())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .modifier(NeonGlassPanel())
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
