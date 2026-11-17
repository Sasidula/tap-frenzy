//
//  ScoreCard.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//

import SwiftUI

struct FallingSparkle: View {

    let screenSize: CGSize
    let index: Int

    @State private var animate = false

    private let pink = Color(
        red: 1.0,
        green: 0.12,
        blue: 0.55
    )

    private var sparkleColor: Color {
        index.isMultiple(of: 2) ? pink : .white
    }

    var body: some View {

        Image(systemName: "sparkle")
            .font(.system(size: CGFloat((index % 4) + 5)))
            .foregroundColor(sparkleColor.opacity(0.7))
            .position(
                x: CGFloat(
                    (index * 47) % max(Int(screenSize.width), 1)
                ),
                y: animate
                    ? screenSize.height + 20
                    : -20
            )
            .animation(
                .linear(duration: Double((index % 5) + 8))
                    .repeatForever(autoreverses: false)
                    .delay(Double(index) * 0.3),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}

