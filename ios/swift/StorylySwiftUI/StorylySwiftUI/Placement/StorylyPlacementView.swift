//
//  StorylyPlacementView.swift
//  StorylySwiftUI
//
//  Created by Kadir Sancak on 20.07.2026.
//

import SwiftUI
import StorylyCore
import StorylyPlacement

/// Renders a Storyly placement inside SwiftUI.
///
/// Storyly ships its widget as a classic UIKit view (`STRPlacementView`); this
/// SwiftUI view bridges it with ``UIViewRepresentable`` and drives the view
/// height from the SDK-reported aspect ratio
///
/// - Parameter dataProvider: caller-owned provider, already configured with a token.
struct StorylyPlacementView: View {

    let dataProvider: STRPlacementDataProvider

    /// Width-to-height ratio reported by the widget once it is laid out; `nil`
    /// until the first `onWidgetReady` callback arrives.
    @State private var aspectRatio: CGFloat?
    /// Whether the placement currently has content to show. Toggled by the SDK
    /// through `onVisibilityChange`.
    @State private var isVisible = true
    /// The width SwiftUI offered us, used to derive the height from the ratio.
    @State private var availableWidth: CGFloat = 0

    /// The height the placement should occupy: `width / ratio` when visible and
    /// ready, otherwise `0` so the view collapses out of the layout.
    private var placementHeight: CGFloat {
        guard isVisible, let aspectRatio, aspectRatio > 0 else { return 0 }
        return availableWidth / aspectRatio
    }

    var body: some View {
        PlacementViewRepresentable(
            dataProvider: dataProvider,
            aspectRatio: $aspectRatio,
            isVisible: $isVisible
        )
        .frame(maxWidth: .infinity)
        .frame(height: placementHeight)
        .clipped()
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.width
        } action: { width in
            availableWidth = width
        }
        .animation(.easeInOut, value: placementHeight)
    }
}

/// Thin ``UIViewRepresentable`` bridge around `STRPlacementView`.
private struct PlacementViewRepresentable: UIViewRepresentable {

    let dataProvider: STRPlacementDataProvider
    @Binding var aspectRatio: CGFloat?
    @Binding var isVisible: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(aspectRatio: $aspectRatio, isVisible: $isVisible)
    }

    func makeUIView(context: Context) -> STRPlacementView {
        let placementView = STRPlacementView(dataProvider: dataProvider)
        placementView.delegate = context.coordinator
        // Needed so widgets can present full-screen story / video experiences.
        placementView.rootViewController = UIApplication.shared.topViewController
        return placementView
    }

    func updateUIView(_ uiView: STRPlacementView, context: Context) {
        if uiView.rootViewController == nil {
            uiView.rootViewController = UIApplication.shared.topViewController
        }
    }

    /// Receives widget lifecycle and interaction events and forwards the ones
    /// that affect layout back into SwiftUI state.
    final class Coordinator: NSObject, STRDelegate {

        private let aspectRatio: Binding<CGFloat?>
        private let isVisible: Binding<Bool>

        init(aspectRatio: Binding<CGFloat?>, isVisible: Binding<Bool>) {
            self.aspectRatio = aspectRatio
            self.isVisible = isVisible
        }

        func onWidgetReady(widget: STRWidgetController, ratio: CGFloat) {
            aspectRatio.wrappedValue = ratio
        }

        func onVisibilityChange(widget: STRWidgetController?, isVisible: Bool) {
            self.isVisible.wrappedValue = isVisible
        }

        func onActionClicked(widget: STRWidgetController, url: String, payload: STRPayload) {
            print("StorylyPlacement onActionClicked: type=\(widget.getType()), url=\(url)")
        }
    }
}

private extension UIApplication {
    var topViewController: UIViewController? {
        let windowScene = connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
            ?? connectedScenes.first as? UIWindowScene
        var top = windowScene?.keyWindow?.rootViewController
            ?? windowScene?.windows.first?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }
}
