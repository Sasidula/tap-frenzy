//
//  LightCardView.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct LightCardView: View {

    // MARK: - Properties

    let card: Card
    let color: Color
    let action: () -> Void

    // MARK: - Body

    var body: some View {

        Button {
            action()
        } label: {

            ZStack {

                // Card background
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        card.isLit
                        ? color.opacity(0.25)
                        : Color.white.opacity(0.045)
                    )

                // Card border
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        card.isLit
                        ? color
                        : Color.white.opacity(0.15),
                        lineWidth: card.isLit ? 2.5 : 1
                    )

                // Card icon
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(
                        card.isLit
                        ? color
                        : Color.white.opacity(0.18)
                    )
                    .shadow(
                        color: card.isLit
                        ? color
                        : .clear,
                        radius: card.isLit ? 20 : 0
                    )
                    .scaleEffect(card.isLit ? 1.2 : 0.85)
            }
            .frame(height: 100)
            .shadow(
                color: card.isLit
                ? color.opacity(0.6)
                : .clear,
                radius: card.isLit ? 15 : 0
            )
            .scaleEffect(card.isLit ? 1.05 : 1.0)
            .animation(
                .spring(response: 0.25, dampingFraction: 0.65),
                value: card.isLit
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Card \(card.id + 1)")
        .accessibilityHint(
            card.isLit
            ? "Illuminated card. Tap to score."
            : "Dark card."
        )
    }
}

// MARK: - Preview

#Preview {
    LightCardView(
        card: Card(id: 0, isLit: true),
        color: .cyan,
        action: {}
    )
    .padding()
    .background(Color.black)
}
