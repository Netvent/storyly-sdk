//
//  PlacementScreen.swift
//  SwiftUIDemo
//
//  Created by Kadir Sancak on 20.07.2026.
//

import Combine
import SwiftUI
import StorylyCore
import StorylyPlacement
import PlacementSwiftUI

/// A typical customer integration: a single Story Bar placement pinned to the top of the
/// screen, rendered with `StorylyPlacementView` from the `PlacementSwiftUI` package.
///
/// The view has no intrinsic size, so sizing is the host's job: ``PlacementState`` records
/// the ratio and visibility the SDK reports, and ``placementHeight`` turns them into a frame.
struct PlacementScreen: View {

    /// Sample Story Bar placement token shipped with the Storyly SDK demos.
    /// Replace it with your own placement token from https://dashboard.storyly.io.
    private static let storyBarToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDY4LCJzZGtfcGwiOiJpb3MifQ.0jBYuIL2vKDSR6is34tRCKViGm5_jfqElkJhSgRL_dE"

    @State private var dataProvider = STRPlacementDataProvider()
    /// The SDK holds its delegate weakly, so the screen has to keep this alive.
    @StateObject private var state = PlacementState()
    /// The width SwiftUI offered us, used to derive the height from the ratio.
    @State private var availableWidth: CGFloat = 0

    /// The height the placement should occupy: `width / ratio` once a widget is ready and
    /// visible, otherwise `0` so it collapses out of the layout.
    private var placementHeight: CGFloat {
        guard state.isVisible, let ratio = state.ratio, ratio > 0, ratio.isFinite else { return 0 }
        return availableWidth / ratio
    }

    var body: some View {
        VStack(spacing: 0) {
            StorylyPlacementView(dataProvider: dataProvider, delegate: state)
                .frame(maxWidth: .infinity)
                .frame(height: placementHeight)
                .clipped()
                .padding(.vertical, 8)
                .onGeometryChange(for: CGFloat.self) { proxy in
                    proxy.size.width
                } action: { width in
                    availableWidth = width
                }
                .animation(.easeInOut, value: placementHeight)

            Divider()

            Text("The Story Bar above is a Storyly placement rendered with StorylyPlacementView.")
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

/// Receives widget lifecycle and interaction events, publishing the ones that affect layout
/// so the screen can size the placement.
@MainActor
final class PlacementState: NSObject, ObservableObject, STRDelegate {

    /// Width-to-height ratio reported once the widget is laid out; `nil` until the first
    /// `onWidgetReady` callback arrives.
    @Published var ratio: CGFloat?
    /// Whether the placement currently has content to show.
    @Published var isVisible = false

    func onWidgetReady(widget: any STRWidgetController, ratio: CGFloat) {
        self.ratio = ratio
    }

    func onVisibilityChange(widget: (any STRWidgetController)?, isVisible: Bool) {
        self.isVisible = isVisible
        if !isVisible { ratio = nil }
    }

    func onActionClicked(widget: any STRWidgetController, url: String, payload: STRPayload) {
        print("StorylyPlacement onActionClicked: type=\(widget.getType()), url=\(url)")
    }
}

#Preview {
    NavigationStack {
        PlacementScreen()
            .navigationTitle("Storyly Placement")
    }
}
