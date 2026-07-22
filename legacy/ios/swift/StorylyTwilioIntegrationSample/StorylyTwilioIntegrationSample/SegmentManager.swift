//
//  SegmentManager.swift
//  StorylyTwilioIntegrationSample
//
//  A thin wrapper around Twilio Segment's analytics-swift SDK that exposes a
//  single shared Analytics instance for the app.
//
//  Setup:
//  1. Add the Segment SPM package:
//     https://github.com/segmentio/analytics-swift  (product: "Segment")
//  2. Replace SEGMENT_WRITE_KEY below with your source's write key from the
//     Segment dashboard (Connections ▸ Sources ▸ <your source> ▸ Settings ▸ API Keys).
//

import Foundation
import Segment

enum SegmentManager {

    /// Your Segment source write key. Replace with your own value.
    private static let writeKey = "YOUR-WRITE-TOKEN"

    /// Shared Analytics instance used throughout the app.
    static let analytics: Analytics = {
        let configuration = Configuration(writeKey: writeKey)
            // Automatically track Application Opened / Installed / Updated, etc.
            .trackApplicationLifecycleEvents(true)
            // Flush after this many events are queued.
            .flushAt(3)
            // Or flush at least this often (seconds).
            .flushInterval(10)
        return Analytics(configuration: configuration)
    }()

    /// Call once, early in the app lifecycle, to spin up the SDK.
    static func start() {
        _ = analytics
    }

    /// Records a Segment `track` call for a single user action.
    ///
    /// - Parameters:
    ///   - event: Human-readable event name (e.g. "StoryGroupOpened").
    ///   - properties: Free-form dictionary describing the event.
    static func track(_ event: String, properties: [String: Any]) {
        analytics.track(name: event, properties: properties)
    }

    /// Records a Segment `identify` call, associating the current (and all
    /// subsequent) events with a known user.
    ///
    /// - Parameters:
    ///   - userId: Your app's unique identifier for the user.
    ///   - traits: Optional attributes describing the user (name, email, plan, …).
    static func identify(_ userId: String, traits: [String: Any] = [:]) {
        if traits.isEmpty {
            analytics.identify(userId: userId)
        } else {
            analytics.identify(userId: userId, traits: traits)
        }
    }
}
