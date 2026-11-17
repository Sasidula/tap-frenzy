//
//  ScoreCard.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct ScoreCard: View {

    let title: String
    let value: Int

    var body: some View {

        VStack(spacing: 8) {

            Text(title)
                .font(.system(size: 10, weight: .bold))
                .tracking(2)
                .foregroundColor(.white.opacity(0.6))

            Text("\(value)")
                .font(.system(
                    size: 30,
                    weight: .black,
                    design: .rounded
                ))
                .foregroundColor(.white)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .modifier(NeonGlassPanel())
    }
}

