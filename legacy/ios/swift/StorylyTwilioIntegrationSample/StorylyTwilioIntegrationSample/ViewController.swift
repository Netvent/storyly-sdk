//
//  ViewController.swift
//  StorylyTwilioIntegrationSample
//
//  Hosts a StorylyView and implements its delegate callbacks.
//

import UIKit
import Storyly

class ViewController: UIViewController {

    // Public demo token shipped with the Storyly sample apps.
    // Replace with your own instance token from the Storyly dashboard.
    private let storylyToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40"

    private lazy var storylyView: StorylyView = {
        let view = StorylyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Storyly"
        setupStorylyView()
    }

    private func setupStorylyView() {
        storylyView.delegate = self
        storylyView.rootViewController = self
        storylyView.storylyInit = StorylyInit(storylyId: storylyToken)

        view.addSubview(storylyView)
        NSLayoutConstraint.activate([
            storylyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            storylyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            storylyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            storylyView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

// MARK: - StorylyDelegate

extension ViewController: StorylyDelegate {

    func storylyLoaded(_ storylyView: StorylyView,
                       storyGroupList: [StoryGroup],
                       dataSource: StorylyDataSource) {
        print("storylyLoaded: \(storyGroupList.count) group(s), source: \(dataSource)")
    }

    func storylyLoadFailed(_ storylyView: StorylyView, errorMessage: String) {
        print("storylyLoadFailed: \(errorMessage)")
    }

    func storylyActionClicked(_ storylyView: StorylyView, rootViewController: UIViewController, story: Story) {
        print("storylyActionClicked: \(story)")
    }

    func storylyStoryPresented(_ storylyView: StorylyView) {
        print("storylyStoryPresented")
    }

    func storylyStoryPresentFailed(_ storylyView: StorylyView, errorMessage: String) {
        print("storylyStoryPresentFailed: \(errorMessage)")
    }

    func storylyStoryDismissed(_ storylyView: StorylyView) {
        print("storylyStoryDismissed")
    }

    func storylyUserInteracted(_ storylyView: StorylyView,
                              storyGroup: StoryGroup,
                              story: Story,
                              storyComponent: StoryComponent) {
        print("storylyUserInteracted: \(storyComponent.type)")
    }

    func storylyEvent(_ storylyView: StorylyView,
                     event: StorylyEvent,
                     storyGroup: StoryGroup?,
                     story: Story?,
                     storyComponent: StoryComponent?) {
        print("storylyEvent: \(event.stringValue)")
    }

    func storylySizeChanged(_ storylyView: StorylyView, size: CGSize) {
        print("storylySizeChanged: \(size)")
    }
}
