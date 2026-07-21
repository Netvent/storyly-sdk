//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Kadir Sancak on 20.07.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            PlacementScreen()
                .navigationTitle("Storyly Placement")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
