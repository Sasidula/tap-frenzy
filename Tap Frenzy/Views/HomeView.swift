//
//  HomeView.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//

import SwiftUI

struct HomeView: View {

    // MARK: - Colours

    private let pink = Color(
        red: 1.0,
        green: 0.12,
        blue: 0.55
    )

    private let purple = Color(
        red: 0.55,
        green: 0.25,
        blue: 1.0
    )

    private let cyan = Color(
        red: 0.0,
        green: 0.85,
        blue: 1.0
    )

    // MARK: - Body

    var body: some View {

        ZStack {

            // Background
            Color.black
                .ignoresSafeArea()

            // Animated background
            SparkleField()
                .ignoresSafeArea()

            VStack(spacing: 30) {

                Spacer()

                // App title
                headerSection

                // Game selection
                VStack(spacing: 20) {

                    Text("CHOOSE YOUR GAME")
                        .font(.system(
                            size: 12,
                            weight: .bold
                        ))
                        .tracking(3)
                        .foregroundColor(.white.opacity(0.6))

                    // Tap Frenzy
                    NavigationLink {
                        TapFrenzyView()
                            .toolbar(.hidden, for: .navigationBar)
                    } label: {

                        gameCard(
                            title: "TAP FRENZY",
                            subtitle: "Test your tapping speed",
                            icon: "hand.tap.fill",
                            color: pink,
                            number: "01"
                        )
                    }
                    .buttonStyle(.plain)

                    // Light It Up
                    NavigationLink {
                        LightItUpView()
                            .toolbar(.hidden, for: .navigationBar)
                    } label: {

                        gameCard(
                            title: "LIGHT IT UP",
                            subtitle: "Challenge your reaction",
                            icon: "lightbulb.fill",
                            color: cyan,
                            number: "02"
                        )
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                // Footer
                footerSection
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 25)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Header

    private var headerSection: some View {

        VStack(spacing: 12) {

            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 45))
                .foregroundColor(pink)
                .shadow(color: pink.opacity(0.8), radius: 15)

            Text("TAP FRENZY")
                .font(.system(
                    size: 38,
                    weight: .black,
                    design: .rounded
                ))
                .foregroundColor(pink)
                .shadow(color: pink.opacity(0.8), radius: 15)

            Text("NEON ARCADE")
                .font(.system(
                    size: 12,
                    weight: .bold,
                    design: .monospaced
                ))
                .tracking(5)
                .foregroundColor(.white.opacity(0.6))

            Text("PLAY. REACT. CONQUER.")
                .font(.system(size: 10, weight: .medium))
                .tracking(2)
                .foregroundColor(.white.opacity(0.4))
                .padding(.top, 5)
        }
    }

    // MARK: - Game Card

    private func gameCard(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        number: String
    ) -> some View {

        HStack(spacing: 18) {

            // Game icon
            Image(systemName: icon)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(color)
                .frame(width: 65, height: 65)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16))

            // Game information
            VStack(alignment: .leading, spacing: 7) {

                Text(title)
                    .font(.system(
                        size: 18,
                        weight: .black,
                        design: .rounded
                    ))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.55))
            }

            Spacer()

            // Game number and arrow
            VStack(spacing: 8) {

                Text(number)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(color)

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(color)
            }
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [
                    color.opacity(0.15),
                    Color.white.opacity(0.03)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.55), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: color.opacity(0.15), radius: 12)
    }

    // MARK: - Footer

    private var footerSection: some View {

        VStack(spacing: 8) {

            Text("MORE GAMES. MORE CHALLENGES.")
                .font(.system(size: 9, weight: .bold))
                .tracking(2)
                .foregroundColor(.white.opacity(0.45))

            Text("TAP FRENZY • TUTORIAL 2")
                .font(.system(size: 9, weight: .medium))
                .tracking(2)
                .foregroundColor(purple.opacity(0.8))
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HomeView()
    }
}
