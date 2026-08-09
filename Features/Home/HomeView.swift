//
//  HomeView.swift
//  Backgammon
//
//  Created by איתי בן שושן on 27/07/2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Backgammon")
                .font(.largeTitle)
                .bold()
            
            Button {
                
            } label: {
                Text("Play")
                    .font(.title2)
                    .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
