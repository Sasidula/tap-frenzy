//
//  NeonGlassPanel.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct NeonGlassPanel: ViewModifier {

    func body(content: Content) -> some View {

        content
            .background(Color.white.opacity(0.045))
            .background(.ultraThinMaterial.opacity(0.25))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        Color.white.opacity(0.13),
                        lineWidth: 1
                    )
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )
    }
}


