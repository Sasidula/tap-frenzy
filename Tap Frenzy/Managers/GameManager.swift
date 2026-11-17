//
//  GameManager.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI
import Combine
import UIKit

class GameManager: ObservableObject {

    @Published var score = 0
    @Published var timeRemaining = 10
    @Published var selectedDuration = 10
    @Published var gamePhase: GamePhase = .idle
    @Published var achievedNewBest = false

    @AppStorage("bestScore") var bestScore = 0
    @AppStorage("gamesPlayed") var gamesPlayed = 0

    private var timer: AnyCancellable?

    init() {
        startTimer()
    }

    private func startTimer() {
        timer = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            self?.updateTimer()
        }
    }

    func handleTap() {

        guard gamePhase != .over else {
            return
        }

        if gamePhase == .idle {
            gamePhase = .playing
        }

        score += 1

        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
    }

    private func updateTimer() {

        guard gamePhase == .playing else {
            return
        }

        if timeRemaining > 1 {
            timeRemaining -= 1
        } else {
            timeRemaining = 0
            finishGame()
        }
    }

    private func finishGame() {

        gamePhase = .over
        gamesPlayed += 1

        if score > bestScore {
            bestScore = score
            achievedNewBest = true
        } else {
            achievedNewBest = false
        }

        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
    }

    func resetGame() {

        score = 0
        timeRemaining = selectedDuration
        achievedNewBest = false
        gamePhase = .idle
    }

    func updateDuration(_ duration: Int) {

        guard gamePhase == .idle else {
            return
        }

        selectedDuration = duration
        timeRemaining = duration
    }
}

