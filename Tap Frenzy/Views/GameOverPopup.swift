//
//  ScoreCard.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct GameOverPopup: View {

    @ObservedObject var game: GameManager

    private let pink = Color(
        red: 1.0,
        green: 0.12,
        blue: 0.55
    )

    var body: some View {

        ZStack {

            Color.black.opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: 22) {

                Text("GAME OVER")
                    .font(.system(
                        size: 29,
                        weight: .black,
                        design: .rounded
                    ))
                    .foregroundColor(pink)
                    .rotationEffect(.degrees(-5))
                    .shadow(color: pink.opacity(0.8), radius: 15)

                Text("YOUR FINAL SCORE")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(3)
                    .foregroundColor(.white.opacity(0.6))

                Text("\(game.score)")
                    .font(.system(
                        size: 65,
                        weight: .black,
                        design: .rounded
                    ))
                    .foregroundColor(.white)
                    .shadow(color: pink.opacity(0.7), radius: 15)

                if game.achievedNewBest {

                    Text("NEW BEST SCORE!")
                        .font(.system(size: 12, weight: .black))
                        .tracking(2)
                        .foregroundColor(pink)
                }

                Button {
                    game.resetGame()
                } label: {

                    Text("PLAY AGAIN")
                        .font(.system(size: 14, weight: .black))
                        .tracking(2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(pink)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                        .shadow(color: pink.opacity(0.6), radius: 12)
                }
                .buttonStyle(.plain)
            }
            .padding(30)
            .frame(maxWidth: 320)
            .modifier(NeonGlassPanel())
            .transition(.scale.combined(with: .opacity))
        }
        .animation(
            .spring(response: 0.4),
            value: game.gamePhase == .over
        )
    }
}
