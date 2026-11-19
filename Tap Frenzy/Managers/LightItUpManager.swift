//
//  LightItUpManager..swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//



import SwiftUI
import Combine

// MARK: - Tap Feedback

enum LightTapFeedback {
    case correct
    case incorrect
}

// MARK: - Light It Up Manager

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

    @Published private(set) var tapFeedback: LightTapFeedback?
    @Published private(set) var feedbackToken = UUID()

    @Published private(set) var levelUpMessage: String?

    // MARK: - High Score

    @AppStorage("lightItUpHighScore")
    private var savedHighScore = 0

    var highScore: Int {
        savedHighScore
    }

    // MARK: - Tasks

    private var gameTask: Task<Void, Never>?
    private var activeCardTask: Task<Void, Never>?
    private var feedbackTask: Task<Void, Never>?
    private var levelTask: Task<Void, Never>?

    // MARK: - Settings

    private let roundDuration = 60
    private let wrongTapCooldown: TimeInterval = 0.75

    private var lastWrongTapDate: Date?
    private var activeEventID: UUID?

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

        tapFeedback = nil
        levelUpMessage = nil

        lastWrongTapDate = nil

        resetCards()
        lightRandomCards()
        startGameTimer()
    }

    // MARK: - Game Timer

    private func startGameTimer() {

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

    // MARK: - Level Progression

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

        // Cancel the previous lighting event.
        cancelLightingEvent()

        // Generate cards for the new level.
        resetCards()

        // Display level-up message.
        showLevelUp()

        // Start a new lighting event.
        lightRandomCards()
    }

    // MARK: - Level-Up Feedback

    private func showLevelUp() {

        levelTask?.cancel()

        levelUpMessage = "LEVEL \(currentLevel.rawValue)!"

        levelTask = Task { [weak self] in

            do {
                try await Task.sleep(
                    nanoseconds: 1_500_000_000
                )
            } catch {
                return
            }

            guard !Task.isCancelled else {
                return
            }

            self?.levelUpMessage = nil
        }
    }

    // MARK: - Random Card Lighting

    private func lightRandomCards() {

        guard isPlaying else {
            return
        }

        cancelLightingEvent()

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
        let eventID = UUID()

        activeEventID = eventID

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

            guard let self,
                  self.isPlaying,
                  self.activeEventID == eventID else {
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

        // Incorrect tap
        guard cards[index].isLit else {

            handleWrongTap()
            return
        }

        // Correct tap
        score += 1

        showTapFeedback(.correct)

        cards[index].isLit = false

        // Continue only when all illuminated cards
        // have been successfully tapped.

        if !cards.contains(where: { $0.isLit }) {

            cancelLightingEvent()

            lightRandomCards()
        }
    }

    // MARK: - Wrong Tap

    private func handleWrongTap() {

        showTapFeedback(.incorrect)

        let now = Date()

        // Prevent repeated penalties from rapid tapping.
        if let lastWrongTapDate,
           now.timeIntervalSince(lastWrongTapDate)
                < wrongTapCooldown {
            return
        }

        lastWrongTapDate = now

        loseLife()
    }

    // MARK: - Tap Feedback

    private func showTapFeedback(_ feedback: LightTapFeedback) {

        feedbackTask?.cancel()

        tapFeedback = feedback
        feedbackToken = UUID()

        feedbackTask = Task { [weak self] in

            do {
                try await Task.sleep(
                    nanoseconds: 450_000_000
                )
            } catch {
                return
            }

            self?.tapFeedback = nil
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

        // One life penalty for one expired event.
        loseLife()

        guard isPlaying else {
            return
        }

        lightRandomCards()
    }

    // MARK: - Lose Life

    private func loseLife() {

        guard isPlaying else {
            return
        }

        lives = max(0, lives - 1)

        if lives == 0 {
            finishGame()
        }
    }

    // MARK: - Cancel Lighting Event

    private func cancelLightingEvent() {

        activeCardTask?.cancel()
        activeCardTask = nil

        activeEventID = nil
    }

    // MARK: - Finish Game

    func finishGame() {

        guard isPlaying else {
            return
        }

        isPlaying = false
        gameOver = true

        // Remove all illuminated cards.
        for index in cards.indices {
            cards[index].isLit = false
        }

        stopTimers()

        if score > savedHighScore {
            savedHighScore = score
        }
    }

    // MARK: - Stop Timers

    private func stopTimers() {

        gameTask?.cancel()
        gameTask = nil

        cancelLightingEvent()

        feedbackTask?.cancel()
        feedbackTask = nil

        levelTask?.cancel()
        levelTask = nil
    }

    // MARK: - Restart Game

    func restartGame() {
        startGame()
    }

    // MARK: - Stop Game

    func stopGame() {

        stopTimers()

        isPlaying = false
        gameOver = false

        tapFeedback = nil
        levelUpMessage = nil
    }
}
