//
//  ContentView.swift
//  Tap Frenzy
//
//  Created by COBSCCOMP252P-044 G3 on 2026-11-17.
//


import SwiftUI

struct ContentView: View {

    var body: some View {

        NavigationStack {

            HomeView()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
