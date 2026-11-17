//
//  LightItUpManager..swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

@MainActor
final class LightItUpManager: ObservableObject {

    // MARK: - Published Game State

    @Published private(set) var cards: [Card] = []

    @Published private(set) var score = 0

    @Published private(set) var lives = 3

    @Published private(set) var timeRemaining = 60

    @Published private(set) var elapsedTime = 0

    @Published private(set) var currentLevel: LightLevel = .beginner

    @Published private(set) var gameOver = false

    @Published private(set) var isPlaying = false

    // MARK: - Saved High Score

    @AppStorage("lightItUpHighScore")
    private var savedHighScore = 0

    var highScore: Int {
        savedHighScore
    }

    // MARK: - Timer Task

    private var gameTask: Task<Void, Never>?

    private var activeCardTask: Task<Void, Never>?

    // MARK: - Round Settings

    private let roundDuration = 60

    // MARK: - Initialization

    init() {
        resetCards()
    }

    // MARK: - Start Game

    func startGame() {

        stopTimers()

        score = 0
        lives = 3
        timeRemaining = roundDuration
        elapsedTime = 0

        currentLevel = .beginner

        gameOver = false
        isPlaying = true

        resetCards()

        lightRandomCards()

        gameTask = Task { [weak self] in

            while !Task.isCancelled {

                do {
                    try await Task.sleep(
                        nanoseconds: 1_000_000_000
                    )
                } catch {
                    return
                }

                guard let self, self.isPlaying else {
                    return
                }

                self.elapsedTime += 1

                self.timeRemaining = max(
                    0,
                    self.roundDuration - self.elapsedTime
                )

                self.updateLevel()

                if self.timeRemaining == 0 {
                    self.finishGame()
                    return
                }
            }
        }
    }

    // MARK: - Reset Cards

    private func resetCards() {

        cards = (0..<currentLevel.cardCount).map {
            Card(id: $0)
        }
    }

    // MARK: - Update Level

    private func updateLevel() {

        let newLevel: LightLevel

        switch elapsedTime {

        case 0..<15:
            newLevel = .beginner

        case 15..<30:
            newLevel = .intermediate

        case 30..<45:
            newLevel = .advanced

        default:
            newLevel = .expert
        }

        guard newLevel != currentLevel else {
            return
        }

        currentLevel = newLevel

        resetCards()

        activeCardTask?.cancel()

        lightRandomCards()
    }

    // MARK: - Random Card Lighting

    private func lightRandomCards() {

        guard isPlaying else {
            return
        }

        activeCardTask?.cancel()

        let availableIDs = cards.map { $0.id }

        guard !availableIDs.isEmpty else {
            return
        }

        let litCount = min(
            currentLevel.simultaneousCardCount,
            availableIDs.count
        )

        let selectedIDs = Array(
            availableIDs.shuffled().prefix(litCount)
        )

        for index in cards.indices {

            cards[index].isLit = selectedIDs.contains(
                cards[index].id
            )
        }

        let duration = currentLevel.litDuration

        activeCardTask = Task { [weak self] in

            do {
                try await Task.sleep(
                    nanoseconds: UInt64(
                        duration * 1_000_000_000
                    )
                )
            } catch {
                return
            }

            guard let self, self.isPlaying else {
                return
            }

            self.handleMissedCards()
        }
    }

    // MARK: - Handle Card Tap

    func handleTap(_ card: Card) {

        guard isPlaying else {
            return
        }

        guard let index = cards.firstIndex(
            where: { $0.id == card.id }
        ) else {
            return
        }

        guard cards[index].isLit else {

            loseLife()

            return
        }

        // Correct tap
        score += 1

        cards[index].isLit = false

        // Level 4 can have two active cards.
        // Continue only when all active cards are cleared.

        if !cards.contains(where: { $0.isLit }) {

            activeCardTask?.cancel()

            lightRandomCards()
        }
    }

    // MARK: - Missed Cards

    private func handleMissedCards() {

        guard isPlaying else {
            return
        }

        let missedCount = cards.filter {
            $0.isLit
        }.count

        guard missedCount > 0 else {
            lightRandomCards()
            return
        }

        loseLife()

        guard isPlaying else {
            return
        }

        // One penalty per expired lighting event,
        // even if two cards were illuminated.

        lightRandomCards()
    }

    // MARK: - Lose Life

    private func loseLife() {

        guard isPlaying else {
            return
        }

        lives -= 1

        if lives <= 0 {

            lives = 0

            finishGame()
        }
    }

    // MARK: - Finish Game

    func finishGame() {

        guard isPlaying else {
            return
        }

        isPlaying = false
        gameOver = true

        stopTimers()

        if score > savedHighScore {
            savedHighScore = score
        }
    }

    // MARK: - Stop Timers

    private func stopTimers() {

        gameTask?.cancel()
        gameTask = nil

        activeCardTask?.cancel()
        activeCardTask = nil
    }

    // MARK: - Restart Game

    func restartGame() {

        stopTimers()

        startGame()
    }

    // MARK: - Return to Idle

    func stopGame() {

        stopTimers()

        isPlaying = false
        gameOver = false
    }
}
