//
//  HomeView.swift
//  Backgammon
//
//  Created by איתי בן שושן on 27/07/2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Backgammon")
                    .font(.largeTitle)
                    .bold()
                    NavigationLink("Play", destination: GameView())
                        .font(.title2)
                        .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
