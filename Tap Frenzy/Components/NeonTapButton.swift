//
//  ScoreCard.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct NeonTapButton: View {

    let action: () -> Void

    private let pink = Color(
        red: 1.0,
        green: 0.12,
        blue: 0.55
    )

    var body: some View {

        Button {
            action()
        } label: {

            ZStack {

                // Outer glow
                Circle()
                    .fill(pink.opacity(0.15))
                    .frame(width: 215, height: 215)
                    .blur(radius: 20)

                // Main circle
                Circle()
                    .fill(pink.opacity(0.12))
                    .frame(width: 185, height: 185)
                    .overlay(
                        Circle()
                            .stroke(pink, lineWidth: 3)
                    )
                    .shadow(color: pink.opacity(0.8), radius: 18)

                // Inner circle
                Circle()
                    .fill(pink)
                    .frame(width: 115, height: 115)
                    .overlay {

                        VStack(spacing: 5) {

                            Text("TAP")
                                .font(.system(
                                    size: 25,
                                    weight: .black,
                                    design: .rounded
                                ))

                            Text("TO SCORE")
                                .font(.system(size: 9, weight: .bold))
                                .tracking(2)
                        }
                        .foregroundColor(.white)
                    }
                    .shadow(color: pink.opacity(0.9), radius: 20)
            }
        }
        .buttonStyle(NeonTapButtonStyle())
    }
}

// MARK: - Button Animation

struct NeonTapButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .shadow(
                color: Color(
                    red: 1.0,
                    green: 0.12,
                    blue: 0.55
                ).opacity(configuration.isPressed ? 1.0 : 0.4),
                radius: configuration.isPressed ? 35 : 12
            )
            .animation(
                .easeOut(duration: 0.15),
                value: configuration.isPressed
            )
    }
}
