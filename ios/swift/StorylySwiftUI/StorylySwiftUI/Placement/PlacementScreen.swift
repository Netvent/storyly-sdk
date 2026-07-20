//
//  PlacementScreen.swift
//  StorylySwiftUI
//
//  Created by Kadir Sancak on 20.07.2026.
//

import SwiftUI
import StorylyCore
import StorylyPlacement

struct PlacementScreen: View {

    /// Sample Story Bar placement token shipped with the Storyly SDK demos.
    /// Replace it with your own placement token from https://dashboard.storyly.io.
    private static let storyBarToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDY4LCJzZGtfcGwiOiJpb3MifQ.0jBYuIL2vKDSR6is34tRCKViGm5_jfqElkJhSgRL_dE"

    @State private var dataProvider = STRPlacementDataProvider()

    var body: some View {
        VStack(spacing: 0) {
            StorylyPlacementView(dataProvider: dataProvider)
                .padding(.vertical, 8)

            Divider()

            Text("The Story Bar above is a Storyly placement embedded with UIViewRepresentable.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(16)

            Spacer()
        }
        .onAppear {
            // Setting `config` triggers the backend fetch, so apply it once.
            guard dataProvider.config.token.isEmpty else { return }
            dataProvider.config = STRPlacementConfig.Builder()
                .build(token: Self.storyBarToken)
        }
    }
}

#Preview {
    NavigationStack {
        PlacementScreen()
            .navigationTitle("Storyly Placement")
    }
}
