//
//  LightItUpView.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct LightItUpView: View {

    private let cyan = Color(
        red: 0.0,
        green: 0.85,
        blue: 1.0
    )

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 25) {

                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 65))
                    .foregroundColor(cyan)
                    .shadow(color: cyan.opacity(0.8), radius: 20)

                Text("LIGHT IT UP")
                    .font(.system(
                        size: 32,
                        weight: .black,
                        design: .rounded
                    ))
                    .foregroundColor(cyan)

                Text("REACTION CHALLENGE")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(3)
                    .foregroundColor(.white.opacity(0.6))

                Text("COMING SOON")
                    .font(.system(size: 14, weight: .black))
                    .tracking(3)
                    .foregroundColor(.white)

                Text("Get ready to test your reaction speed!")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    LightItUpView()
}
