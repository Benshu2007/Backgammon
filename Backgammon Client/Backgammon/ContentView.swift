//
//  ContentView.swift
//  Backgammon
//
//  Created by איתי בן שושן on 27/07/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
