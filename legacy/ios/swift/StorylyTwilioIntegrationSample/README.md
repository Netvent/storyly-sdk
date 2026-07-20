# StorylyTwilioIntegrationSample

A minimal UIKit sample app that integrates the [Storyly iOS SDK](https://github.com/Netvent/storyly-ios) via **Swift Package Manager**.

## What's inside

- A UIKit app (AppDelegate + SceneDelegate + storyboard) targeting **iOS 14.0+**.
- Storyly **4.20.0** added as an SPM package dependency.
- A `StorylyView` embedded in `ViewController`, wired up with the full `StorylyDelegate` implementation.
- A public demo token so stories load out of the box.

## Getting started

1. Open **`StorylyTwilioIntegrationSample.xcworkspace`** (not the `.xcodeproj`) in Xcode 15+.
2. Wait for Xcode to resolve the Swift package (File ▸ Packages ▸ Resolve Package Versions if needed).
3. Select the `StorylyTwilioIntegrationSample` scheme and a simulator, then Run.

## Using your own token

Replace the `storylyToken` value in `ViewController.swift` with your own instance token
from the [Storyly dashboard](https://dashboard.storyly.io).

## Delegate callbacks

`ViewController` conforms to `StorylyDelegate` and logs the key lifecycle events:
`storylyLoaded`, `storylyLoadFailed`, `storylyActionClicked`, `storylyStoryPresented`,
`storylyStoryPresentFailed`, `storylyStoryDismissed`, `storylyUserInteracted`,
`storylyEvent`, and `storylySizeChanged`.
