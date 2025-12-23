//
//  ViewController.swift
//  PlacementTestIOS3
//
//  Created by Yiğit Atik on 2.12.2025.
//

import UIKit
import StorylyCore
import StorylyPlacement

class ViewController: UIViewController {

    // Adjust this when widget reports its ratio
    private var placementHeightConstraint: NSLayoutConstraint?

    // MARK: - Core Placement Blocks

    // 1) Placement Data Provider
    private lazy var placementProvider: PlacementDataProvider = {
        let provider = PlacementDataProvider()
        provider.delegate = self            // STRProviderDelegate
        // If you need hydration later:
        // provider.productDelegate = self  // STRProviderProductDelegate
        return provider
    }()

    // 2) Placement View
    private var placementView: STRPlacementView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupPlacementConfig()
        setupPlacementView()
    }
}

// MARK: - Placement Config

extension ViewController {
    private func setupPlacementConfig() {
        placementProvider.config = STRPlacementConfig.Builder()
            .build(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MTcxODUsImluc19pZCI6MTkxMDB9.AmtkzTlj_g3RQwwHZTz6rsozH8VFqAogeSwgBdXLMDU")
    }

    private func setupPlacementView() {
        placementView = STRPlacementView(dataProvider: placementProvider)
        placementView.delegate = self    // STRDelegate
        // NOTE: we do NOT add to the hierarchy here.
        // Layout is handled in onWidgetReady.
    }
}

// MARK: - STRProviderDelegate

extension ViewController: STRProviderDelegate {
    func onLoad(data: STRDataPayload, dataSource: STRDataSource) {
        print("placementProvider onLoad: dataSource=\(dataSource)")
        // Ideal place to hide skeletons, etc.
    }

    func onLoadFail(errorMessage: String) {
        print("placementProvider onLoadFail: \(errorMessage)")
        // Show fallback UI if needed
    }
}

// MARK: - STRDelegate (Widget lifecycle / sizing / actions)

extension ViewController: STRDelegate {

    func onWidgetReady(widget: STRWidgetController, ratio: CGFloat) {
        print("Hello ONwİDGETr")
        // Attach placementView to the hierarchy when the widget is ready
        if placementView.superview == nil {
            placementView.rootViewController = self
            placementView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(placementView)

            let guide = view.safeAreaLayoutGuide

            NSLayoutConstraint.activate([
                placementView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                placementView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                placementView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16)
            ])

            // Create a height constraint; we'll update it using the ratio
            let heightConstraint = placementView.heightAnchor.constraint(equalToConstant: 0)
            heightConstraint.isActive = true
            placementHeightConstraint = heightConstraint
        }

        // Handle size based on the reported ratio
        let width = view.bounds.width
        guard width > 0 else {
            print("onWidgetReady: width is 0, skipping layout")
            return
        }

        let height = width / ratio
        placementHeightConstraint?.constant = height

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }

        print("onWidgetReady: widget=\(type(of: widget)), ratio=\(ratio)")
    }

    func onActionClicked(widget: STRWidgetController, url: String, payload: STRPayload) {
        print("onActionClicked url=\(url), payload=\(payload)")
        // In real use: open deep link or routing
    }

    func onEvent(widget: STRWidgetController, payload: STREventPayload) {
        // Forward to your analytics system if desired
        print("onEvent: \(payload)")
    }

    func onFail(widget: STRWidgetController, payload: STRErrorPayload) {
        // Widget-level error fallback (different from provider load fail)
        print("Widget onFail: \(payload)")
    }
}
