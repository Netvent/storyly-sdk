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


    private lazy var placementProvider: PlacementDataProvider = {
        let provider = PlacementDataProvider()
        provider.delegate = self
        return provider
    }()


    private var placementView: STRPlacementView!



    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupPlacementConfig()
        setupPlacementView()
    }
}


extension ViewController {
    private func setupPlacementConfig() {
        placementProvider.config = STRPlacementConfig.Builder()
            .build(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MTcxODUsImluc19pZCI6MTkxMDB9.AmtkzTlj_g3RQwwHZTz6rsozH8VFqAogeSwgBdXLMDU")
    }

    private func setupPlacementView() {
        placementView = STRPlacementView(dataProvider: placementProvider)
        placementView.delegate = self
        placementView.rootViewController = self
        placementView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placementView)

        let guide = view.safeAreaLayoutGuide

        self.placementHeightConstraint = placementView.heightAnchor.constraint(equalToConstant: 0)
        placementHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            placementView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            placementView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            placementView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16)
        ])
    }
}



extension ViewController: STRProviderDelegate {
    func onLoad(data: STRDataPayload, dataSource: STRDataSource) {
        print("placementProvider onLoad: dataSource=\(dataSource)")
    }

    func onLoadFail(errorMessage: String) {
        print("placementProvider onLoadFail: \(errorMessage)")
    }
}



extension ViewController: STRDelegate {

    func onWidgetReady(widget: STRWidgetController, ratio: CGFloat) {

        let height = self.view.frame.width / ratio
        placementHeightConstraint?.constant = height

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }

        print("onWidgetReady: widget=\(type(of: widget)), ratio=\(ratio)")
    }

    func onActionClicked(widget: STRWidgetController, url: String, payload: STRPayload) {
        print("onActionClicked url=\(url), payload=\(payload)")
        // In real use: open deep link or implement routing
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
