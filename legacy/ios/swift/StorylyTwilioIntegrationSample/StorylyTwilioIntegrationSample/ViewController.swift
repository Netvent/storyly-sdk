//
//  ViewController.swift
//  StorylyTwilioIntegrationSample
//
//  Hosts a StorylyView and implements its delegate callbacks.
//

import UIKit
import Storyly
import Segment

class ViewController: UIViewController {

    // Public demo token shipped with the Storyly sample apps.
    // Replace with your own instance token from the Storyly dashboard.
    private let storylyToken = "YOUR-STORYLY-INSTANCE-TOKEN"

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
        storylyView.productDelegate = self
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

        // Identify the current user once Storyly has data. Replace this dummy
        // user with your real user id/traits in a production integration.
        SegmentManager.identify("demo-user-123", traits: [
            "name": "Demo User",
            "email": "demo.user@example.com",
            "plan": "free"
        ])
    }

    func storylyEvent(_ storylyView: StorylyView,
                     event: StorylyEvent,
                     storyGroup: StoryGroup?,
                     story: Story?,
                     storyComponent: StoryComponent?) {
        print("storylyEvent: \(event.stringValue)")

        // Forward every Storyly event to Twilio Segment as a `track` call.
        // The event name becomes the Segment event; the story context becomes
        // the event properties.
        let properties = SegmentEventMapper.properties(storyGroup: storyGroup,
                                                       story: story,
                                                       storyComponent: storyComponent)
        SegmentManager.track(event.stringValue, properties: properties)
    }
}

// MARK: - StorylyProductDelegate

extension ViewController: StorylyProductDelegate {

    // Cart events (add / update / remove / checkout, etc.). Map the cart context
    // to Segment properties, forward it as a `track` call, then confirm the
    // operation so the Storyly UI can proceed. In a real integration you'd apply
    // the change to your own cart and return the updated STRCart via onSuccess.
    func storylyUpdateCartEvent(storylyView: StorylyView,
                                event: StorylyEvent,
                                cart: STRCart?,
                                change: STRCartItem?,
                                onSuccess: ((STRCart?) -> Void)?,
                                onFail: ((STRCartEventResult) -> Void)?) {
        print("storylyUpdateCartEvent: \(event.stringValue)")

        let properties = SegmentEventMapper.cartProperties(event: event, cart: cart, change: change)
        SegmentManager.track(event.stringValue, properties: properties)

        // Optimistically accept the change in this demo.
        onSuccess?(cart)
    }

    // Product events that are neither cart mutations nor wishlist updates
    // (e.g. StoryProductSheetOpened, StoryProductSelected, StoryCheckoutButtonClicked)
    // arrive here with just the event. Map and track them like the others.
    // The selector (storylyEvent:event:) differs from the main delegate's
    // storylyEvent:event:storyGroup:story:storyComponent:, so both coexist.
    func storylyEvent(_ storylyView: StorylyView, event: StorylyEvent) {
        print("storylyEvent (product): \(event.stringValue)")

        let properties = SegmentEventMapper.properties(event: event,
                                                       storyGroup: nil,
                                                       story: nil,
                                                       storyComponent: nil)
        SegmentManager.track(event.stringValue, properties: properties)
    }

    // Wishlist events (add / remove). Same pattern as the cart events.
    func storylyUpdateWishlistEvent(storylyView: StorylyView,
                                    item: STRProductItem?,
                                    event: StorylyEvent,
                                    onSuccess: ((STRProductItem?) -> Void)?,
                                    onFail: ((STRWishlistEventResult) -> Void)?) {
        print("storylyUpdateWishlistEvent: \(event.stringValue)")

        let properties = SegmentEventMapper.wishlistProperties(event: event, item: item)
        SegmentManager.track(event.stringValue, properties: properties)

        // Optimistically accept the change in this demo.
        onSuccess?(item)
    }

}
