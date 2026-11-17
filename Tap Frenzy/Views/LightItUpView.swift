//
//  LightItUpView.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct LightItUpView: View {

    // MARK: - Game Manager

    @StateObject private var manager = LightItUpManager()

    @Environment(\.dismiss) private var dismiss

    // MARK: - Colours

    private let backgroundColor = Color.black

    private let pink = Color(
        red: 1.0,
        green: 0.12,
        blue: 0.55
    )

    private let cyan = Color(
        red: 0.0,
        green: 0.85,
        blue: 1.0
    )

    // MARK: - Grid Layout

    private var gridColumns: [GridItem] {

        Array(
            repeating: GridItem(
                .flexible(),
                spacing: 12
            ),
            count: manager.currentLevel.columnCount
        )
    }

    // MARK: - Body

    var body: some View {

        ZStack {

            // Background
            backgroundColor
                .ignoresSafeArea()

            // Sparkle animation
            SparkleField()
                .ignoresSafeArea()

            VStack(spacing: 22) {

                // Header
                headerSection

                // Score and lives
                statisticsSection

                // Timer
                timerSection

                // Level information
                levelSection

                Spacer(minLength: 5)

                // Interactive cards
                cardGrid

                Spacer(minLength: 5)

                // Game instructions
                instructionSection
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 15)

            // Start screen
            if !manager.isPlaying && !manager.gameOver {
                startOverlay
            }

            // Game over screen
            if manager.gameOver {
                gameOverOverlay
            }
        }
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            manager.stopGame()
        }
    }

    // MARK: - Header

    private var headerSection: some View {

        VStack(spacing: 7) {

            HStack {

                Button {
                    dismiss()
                } label: {

                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Circle())
                }

                Spacer()

                Text("LIGHT IT UP")
                    .font(.system(
                        size: 27,
                        weight: .black,
                        design: .rounded
                    ))
                    .foregroundColor(cyan)
                    .shadow(color: cyan.opacity(0.7), radius: 12)

                Spacer()

                Image(systemName: "bolt.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(cyan)
                    .frame(width: 42, height: 42)
            }

            Text("REACTION CHALLENGE")
                .font(.system(size: 10, weight: .bold))
                .tracking(4)
                .foregroundColor(.white.opacity(0.5))
        }
    }

    // MARK: - Statistics

    private var statisticsSection: some View {

        HStack(spacing: 12) {

            // Score
            statisticCard(
                title: "SCORE",
                value: "\(manager.score)",
                color: cyan,
                icon: "star.fill"
            )

            // High score
            statisticCard(
                title: "BEST",
                value: "\(manager.highScore)",
                color: pink,
                icon: "trophy.fill"
            )

            // Lives
            VStack(spacing: 10) {

                Text("LIVES")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.55))

                HStack(spacing: 4) {

                    ForEach(0..<3, id: \.self) { index in

                        Image(systemName: "heart.fill")
                            .font(.system(size: 13))
                            .foregroundColor(
                                index < manager.lives
                                ? pink
                                : Color.gray.opacity(0.25)
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .modifier(NeonGlassPanel())
        }
    }

    // MARK: - Statistic Card

    private func statisticCard(
        title: String,
        value: String,
        color: Color,
        icon: String
    ) -> some View {

        VStack(spacing: 8) {

            Text(title)
                .font(.system(size: 10, weight: .bold))
                .tracking(2)
                .foregroundColor(.white.opacity(0.55))

            HStack(spacing: 5) {

                Image(systemName: icon)
                    .font(.system(size: 11))
                    .foregroundColor(color)

                Text(value)
                    .font(.system(
                        size: 23,
                        weight: .black,
                        design: .rounded
                    ))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .modifier(NeonGlassPanel())
    }

    // MARK: - Timer

    private var timerSection: some View {

        VStack(spacing: 10) {

            HStack {

                Text("TIME REMAINING")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.55))

                Spacer()

                Text("\(manager.timeRemaining)s")
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(
                        manager.timeRemaining <= 10
                        ? pink
                        : .white
                    )
                    .contentTransition(.numericText())
            }

            ProgressView(
                value: Double(manager.timeRemaining),
                total: 60
            )
            .tint(
                manager.timeRemaining <= 10
                ? pink
                : cyan
            )
            .scaleEffect(x: 1, y: 1.6)
        }
        .padding(.horizontal, 5)
    }

    // MARK: - Level Section

    private var levelSection: some View {

        HStack {

            VStack(alignment: .leading, spacing: 5) {

                Text("CURRENT LEVEL")
                    .font(.system(size: 9, weight: .bold))
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.5))

                Text(manager.currentLevel.title)
                    .font(.system(
                        size: 17,
                        weight: .black,
                        design: .rounded
                    ))
                    .foregroundColor(manager.currentLevel.color)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 5) {

                Text("REACTION TIME")
                    .font(.system(size: 9, weight: .bold))
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.5))

                Text(
                    String(
                        format: "%.1f SEC",
                        manager.currentLevel.litDuration
                    )
                )
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
            }
        }
        .padding(15)
        .modifier(NeonGlassPanel())
    }

    // MARK: - Card Grid

    private var cardGrid: some View {

        LazyVGrid(
            columns: gridColumns,
            spacing: 12
        ) {

            ForEach(manager.cards) { card in

                LightCardView(
                    card: card,
                    color: manager.currentLevel.color
                ) {
                    manager.handleTap(card)
                }
            }
        }
        .padding(.vertical, 5)
        .animation(
            .spring(response: 0.4),
            value: manager.currentLevel
        )
    }

    // MARK: - Instructions

    private var instructionSection: some View {

        HStack(spacing: 8) {

            Image(systemName: "hand.tap.fill")
                .foregroundColor(cyan)

            Text("TAP THE ILLUMINATED CARDS!")
                .font(.system(size: 10, weight: .bold))
                .tracking(1.5)
                .foregroundColor(.white.opacity(0.65))
        }
        .padding(.vertical, 12)
    }

    // MARK: - Start Overlay

    private var startOverlay: some View {

        ZStack {

            Color.black.opacity(0.88)
                .ignoresSafeArea()

            VStack(spacing: 23) {

                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 65))
                    .foregroundColor(cyan)
                    .shadow(color: cyan.opacity(0.8), radius: 25)

                Text("LIGHT IT UP")
                    .font(.system(
                        size: 30,
                        weight: .black,
                        design: .rounded
                    ))
                    .foregroundColor(cyan)

                Text("TEST YOUR REACTION SPEED")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.6))

                VStack(spacing: 12) {

                    instructionRow(
                        icon: "lightbulb.fill",
                        text: "Tap illuminated cards"
                    )

                    instructionRow(
                        icon: "heart.fill",
                        text: "You have 3 lives"
                    )

                    instructionRow(
                        icon: "clock.fill",
                        text: "Survive for 60 seconds"
                    )
                }
                .padding(.vertical, 10)

                Button {
                    manager.startGame()
                } label: {

                    HStack(spacing: 10) {

                        Image(systemName: "play.fill")

                        Text("START GAME")
                            .tracking(2)
                    }
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: cyan.opacity(0.5), radius: 15)
                }
                .buttonStyle(.plain)
            }
            .padding(28)
            .frame(maxWidth: 340)
            .modifier(NeonGlassPanel())
        }
    }

    // MARK: - Instruction Row

    private func instructionRow(
        icon: String,
        text: String
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundColor(cyan)
                .frame(width: 25)

            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))

            Spacer()
        }
    }

    // MARK: - Game Over Overlay

    private var gameOverOverlay: some View {

        ZStack {

            Color.black.opacity(0.9)
                .ignoresSafeArea()

            VStack(spacing: 22) {

                Image(systemName: "flag.checkered")
                    .font(.system(size: 50))
                    .foregroundColor(pink)
                    .shadow(color: pink.opacity(0.7), radius: 20)

                Text("ROUND OVER")
                    .font(.system(
                        size: 30,
                        weight: .black,
                        design: .rounded
                    ))
                    .foregroundColor(pink)

                Text("YOUR FINAL SCORE")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(3)
                    .foregroundColor(.white.opacity(0.6))

                Text("\(manager.score)")
                    .font(.system(
                        size: 65,
                        weight: .black,
                        design: .rounded
                    ))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())

                HStack(spacing: 8) {

                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)

                    Text("BEST SCORE: \(manager.highScore)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }

                Text(
                    manager.lives == 0
                    ? "YOU RAN OUT OF LIVES!"
                    : "TIME'S UP!"
                )
                .font(.system(size: 11, weight: .bold))
                .tracking(2)
                .foregroundColor(.white.opacity(0.55))

                // Play Again
                Button {
                    manager.restartGame()
                } label: {

                    HStack(spacing: 10) {

                        Image(systemName: "arrow.clockwise")

                        Text("PLAY AGAIN")
                            .tracking(2)
                    }
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)

                // Return Home
                Button {
                    dismiss()
                } label: {

                    Text("RETURN HOME")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(2)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 5)
            }
            .padding(30)
            .frame(maxWidth: 340)
            .modifier(NeonGlassPanel())
        }
        .transition(.opacity.combined(with: .scale))
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LightItUpView()
    }
}
