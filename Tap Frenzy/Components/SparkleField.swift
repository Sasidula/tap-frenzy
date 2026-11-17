//
//  ScoreCard.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct SparkleField: View {

    var body: some View {

        GeometryReader { geometry in

            ForEach(0..<22, id: \.self) { index in

                FallingSparkle(
                    screenSize: geometry.size,
                    index: index
                )
            }
        }
        .allowsHitTesting(false)
    }
}
