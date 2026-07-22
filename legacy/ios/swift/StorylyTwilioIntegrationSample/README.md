# Storyly × Twilio Segment Integration (iOS)

A minimal UIKit sample that shows how to forward **Storyly** events to **Twilio Segment**
using Segment's [analytics-swift](https://github.com/segmentio/analytics-swift) SDK. Every
story, interactive, and commerce event Storyly emits is mapped to a Segment `track` call,
and the user is tied to their activity with an `identify` call.

- UIKit app targeting **iOS 14.0+**, Storyly **4.20.0** added via Swift Package Manager.
- A public demo token so stories load out of the box.
- Segment wiring lives in three files: `SegmentManager.swift`, `SegmentEventMapper.swift`,
  and `ViewController.swift`.

---

## 1. Aim of this integration

The goal is to turn Storyly's in-app engagement and shoppable-commerce activity into
first-class analytics events inside Twilio Segment, **without** binding your analytics
pipeline to Storyly-specific code.

Concretely, the integration lets you:

- **Capture the full Storyly funnel** — group opens, story views/completions, interactive
  answers (polls, quizzes, emoji, rating), CTA/button/swipe clicks, and the shoppable
  commerce flow (cart and wishlist changes).
- **Forward everything to Segment once**, then fan it out to any Segment destination
  (warehouses, product analytics, marketing, CDPs) with no extra client code.
- **Attribute events to real users** via `identify`, while still collecting anonymous
  activity before a user is known.
- **Keep the mapping in one place** (`SegmentEventMapper`) so the payload sent to Segment
  is consistent, JSON-serializable, and easy to evolve.

---

## 2. How the Twilio Segment integration works

Setup, end to end:

1. **Add the SDKs (Swift Package Manager).**
   - Storyly: `https://github.com/Netvent/storyly-ios`
   - Segment: `https://github.com/segmentio/analytics-swift` (add the **Segment** product to the app target)
2. **Configure the Segment client.** `SegmentManager` owns a single shared `Analytics`
   instance built from a `Configuration`. Replace the `writeKey` with your source's write
   key (Segment dashboard ▸ Connections ▸ Sources ▸ *your source* ▸ Settings ▸ API Keys).

   ```swift
   static let analytics: Analytics = {
       let configuration = Configuration(writeKey: writeKey)
           .trackApplicationLifecycleEvents(true)  // Application Opened / Installed / Updated
           .flushAt(3)                              // flush after 3 queued events
           .flushInterval(10)                       // …or at least every 10s
       return Analytics(configuration: configuration)
   }()
   ```

3. **Wire the delegates.** In `ViewController.setupStorylyView()` the view controller is set
   as both `storylyView.delegate` (story events) and `storylyView.productDelegate`
   (commerce events).
4. **Map and send.** Each delegate callback builds a properties dictionary with
   `SegmentEventMapper` and hands it to `SegmentManager`.

`SegmentManager` exposes thin wrappers over the SDK:

| Wrapper | Calls | Purpose |
| --- | --- | --- |
| `track(_:properties:)` | `analytics.track(name:properties:)` | One user action; the Storyly event name is the Segment event name. |
| `identify(_:traits:)` | `analytics.identify(userId:traits:)` | Ties subsequent events to a known user. |

Data flow:

```
StorylyView ──(delegate callback)──▶ ViewController
                                        │  builds properties
                                        ▼
                                 SegmentEventMapper  ──▶ [String: Any]
                                        │
                                        ▼
                                  SegmentManager  ──▶ analytics.track / identify
                                        │
                                        ▼
                                   Twilio Segment  ──▶ downstream destinations
```

In this sample:

- `storylyLoaded(...)` → `SegmentManager.identify("demo-user-123", traits: [...])`
- every event callback → `SegmentManager.track(event.stringValue, properties:)`

---

## 3. Identify and anonymous ID generation in Twilio Segment

**Anonymous ID (automatic).** On first launch the Segment SDK generates an `anonymousId`
(a UUID) and persists it on disk. Every `track` and `identify` call automatically
carries this `anonymousId`, so you collect activity **before** you know who the user is.
Because it's device-persisted, the same anonymous visitor stays stable across app launches.

**Identify (tying activity to a user).** When you call:

```swift
SegmentManager.identify("demo-user-123", traits: [
    "name": "Demo User",
    "email": "demo.user@example.com",
    "plan": "free"
])
```

Segment writes that `userId` to disk and attaches it to every subsequent event. Segment can
then stitch the earlier anonymous activity to the identified user, and — because the `userId`
is your own stable identifier — connect the same user across devices (e.g. iPhone + iPad).
`traits` are optional attributes about the user (name, email, plan, …).

In this sample `identify` is called from `storylyLoaded` with a **dummy** user; replace it
with your real user id and traits in production. If you have no user id yet, you can omit it
and send only traits (`analytics.identify(traits:)`), and events continue under the
`anonymousId`.

**Resetting on logout.** Call `analytics.reset()` when a user logs out. It clears the stored
`userId`/traits, and a **new** `anonymousId` is generated on the next app open — so the next
session isn't attributed to the previous user.

**Custom anonymous IDs (optional).** If you need to control the value, supply an
`anonymousIdGenerator` in the `Configuration` instead of relying on Segment's default UUID.

---

## 4. What does the event mapper do?

`SegmentEventMapper` is a **pure, stateless transformer** (a Swift `enum` with only static
functions) that converts the objects Storyly hands back in its delegate callbacks into a
single JSON-serializable `[String: Any]` dictionary suitable for Segment `track` properties.

Key behaviors:

- **Nested shape that mirrors the domain.** The story group, story, and interactive
  component each become a nested sub-dictionary; repeated objects (products, variants,
  colors) become nested arrays.
- **Full property coverage.** It reads every public instance property of `StoryGroup`
  (plus its `style`/`badge`), `Story`, all interactive `StoryComponent` subclasses, and the
  commerce types `STRCart`, `STRCartItem`, `STRProductItem`, `STRProductVariant`.
- **Casts subclasses.** `StoryComponent` is an abstract base; the mapper switches over the
  concrete types (quiz, image quiz, poll, emoji, rating, promo code, comment, swipe, button,
  product card/tag/catalog) to pull out each one's type-specific fields.
- **Makes values serializable.** `URL` → `absoluteString`, `UIColor` → `#RRGGBBAA` hex,
  `NSNumber` → `Int`/`Float`/`Double`, and optional values are simply omitted when `nil`.

Entry points:

| Function | Used for | Produces (top-level keys) |
| --- | --- | --- |
| `properties(event:storyGroup:story:storyComponent:)` | Story & interactive events | `event`, `event_raw_value`, `story_group`, `story`, `component` |
| `cartProperties(event:cart:change:)` | Cart events | `event`, `event_raw_value`, `cart`, `change` |
| `wishlistProperties(event:item:)` | Wishlist events | `event`, `event_raw_value`, `product` |

Example output for a quiz answer:

```json
{
  "event": "StoryQuizAnswered",
  "event_raw_value": 20,
  "story_group": { "id": "…", "title": "…", "index": 0, "seen": true, "type": "default" },
  "story": { "id": "…", "title": "…", "index": 1, "seen": false, "current_time": 3200 },
  "component": {
    "id": "…", "type": "Quiz",
    "title": "Pick one", "options": ["A", "B"], "selected_index": 1, "right_answer_index": 0
  }
}
```

---

## 5. Which delegate functions send events?

Storyly emits events through **two** delegates. Set both on the `StorylyView`:

```swift
storylyView.delegate = self         // StorylyDelegate — story & interactive events
storylyView.productDelegate = self  // StorylyProductDelegate — commerce events
```

### 5.1 `StorylyDelegate.storylyEvent` — the main event stream

```swift
func storylyEvent(_ storylyView: StorylyView,
                  event: StorylyEvent,
                  storyGroup: StoryGroup?,
                  story: Story?,
                  storyComponent: StoryComponent?)
```

| Parameter | Type | Description |
| --- | --- | --- |
| `storylyView` | `StorylyView` | The view instance that produced the event. |
| `event` | `StorylyEvent` | The event type; `event.stringValue` gives its name. |
| `storyGroup` | `StoryGroup?` | The story group the event relates to, if any. |
| `story` | `Story?` | The story the event relates to, if any. |
| `storyComponent` | `StoryComponent?` | The interactive component involved, if the event is component-related. |

Use this for **all non-commerce events**. Map with `SegmentEventMapper.properties(...)`.

### 5.2 `StorylyProductDelegate.storylyUpdateCartEvent` — cart mutations

```swift
func storylyUpdateCartEvent(storylyView: StorylyView,
                            event: StorylyEvent,
                            cart: STRCart?,
                            change: STRCartItem?,
                            onSuccess: ((STRCart?) -> Void)?,
                            onFail: ((STRCartEventResult) -> Void)?)
```

| Parameter | Type | Description |
| --- | --- | --- |
| `storylyView` | `StorylyView` | The view instance that produced the event. |
| `event` | `StorylyEvent` | The cart event type (add / update / remove). |
| `cart` | `STRCart?` | Snapshot of the cart (items, total price, currency). |
| `change` | `STRCartItem?` | The single item being added/updated/removed. |
| `onSuccess` | `((STRCart?) -> Void)?` | Call to confirm the change succeeded; return the updated cart. |
| `onFail` | `((STRCartEventResult) -> Void)?` | Call to report failure with a message. |

You **must** call `onSuccess` (or `onFail`) so the Storyly UI can proceed. Map with
`SegmentEventMapper.cartProperties(...)`. In a real app, apply the change to your own cart
and pass the updated `STRCart` to `onSuccess`.

### 5.3 `StorylyProductDelegate.storylyUpdateWishlistEvent` — wishlist changes

```swift
func storylyUpdateWishlistEvent(storylyView: StorylyView,
                                item: STRProductItem?,
                                event: StorylyEvent,
                                onSuccess: ((STRProductItem?) -> Void)?,
                                onFail: ((STRWishlistEventResult) -> Void)?)
```

| Parameter | Type | Description |
| --- | --- | --- |
| `storylyView` | `StorylyView` | The view instance that produced the event. |
| `item` | `STRProductItem?` | The product being added to / removed from the wishlist. |
| `event` | `StorylyEvent` | The wishlist event type (added / removed). |
| `onSuccess` | `((STRProductItem?) -> Void)?` | Call to confirm the change; return the product. |
| `onFail` | `((STRWishlistEventResult) -> Void)?` | Call to report failure with a message. |

Map with `SegmentEventMapper.wishlistProperties(...)`, then call `onSuccess`/`onFail`.

### 5.4 `StorylyProductDelegate.storylyEvent` — remaining commerce events

```swift
func storylyEvent(_ storylyView: StorylyView, event: StorylyEvent)
```

| Parameter | Type | Description |
| --- | --- | --- |
| `storylyView` | `StorylyView` | The view instance that produced the event. |
| `event` | `StorylyEvent` | The commerce event type (no story context is provided here). |

This fires for product events that are neither cart mutations nor wishlist updates (e.g.
product sheet opened, checkout tapped). Its Objective-C selector (`storylyEvent:event:`)
differs from the main delegate's (`storylyEvent:event:storyGroup:story:storyComponent:`), so
both coexist on the same class. Map with `SegmentEventMapper.properties(event:...)` passing
`nil` for the story context.

> There is also `storylyHydration(_:products:)` on the product delegate. It is **not** an
> analytics event — Storyly calls it to request full product data for the product IDs found
> in your stories. Handle it by supplying your catalog data, not by tracking.

---

## 6. Related events per delegate function

Storyly routes each `StorylyEvent` to exactly one of the callbacks above, so tracking in all
of them gives full coverage with no double-counting.

### `StorylyDelegate.storylyEvent` (story & interactive)

- **Story group:** `StoryGroupOpened`, `StoryGroupUserOpened`, `StoryGroupDeepLinkOpened`,
  `StoryGroupProgrammaticallyOpened`, `StoryGroupCompleted`, `StoryGroupPreviousSwiped`,
  `StoryGroupNextSwiped`, `StoryGroupClosed` — how users enter, move through, and leave groups.
- **Story playback:** `StoryImpression`, `StoryViewed`, `StoryCompleted`,
  `StoryPreviousClicked`, `StoryNextClicked`, `StoryPaused`, `StoryResumed`, `StorySeeked`,
  `StoryShared`, `StoryLiked` — per-story viewing and playback behavior.
- **Interactive components:** `StoryCTAClicked`, `StoryButtonActionClicked`,
  `StoryImageButtonActionClicked`, `StorySwipeActionClicked`, `StoryEmojiClicked`,
  `StoryPollAnswered`, `StoryQuizAnswered`, `StoryImageQuizAnswered`, `StoryRated`,
  `StoryCountdownReminderAdded`, `StoryCountdownReminderRemoved`, `StoryInteractiveImpression`,
  `StoryPromoCodeCopied`, `StoryCommentSent`, `StoryCommentInputOpened`,
  `StoryCommentInputClosed`, `StoryProductTagExpanded`, `StoryProductTagClicked`,
  `StoryProductCardClicked`, `StoryProductCatalogClicked` — reactions to and clicks on
  interactive layers (including product tag/card/catalog clicks).
- **Bar:** `StorylyBarImpression` — the story bar became visible with new content.

### `StorylyProductDelegate.storylyUpdateCartEvent` (cart mutations)

- `StoryProductAdded` — a product was added to the cart.
- `StoryProductUpdated` — a cart line item changed (e.g. quantity).
- `StoryProductRemoved` — a product was removed from the cart.

These carry the `cart` and `change` context and expect an `onSuccess`/`onFail` response.

### `StorylyProductDelegate.storylyEvent` (other commerce events)

- `StoryProductSheetOpened` — the product detail sheet was opened.
- `StoryProductSelected` — a product was selected (e.g. a variant/product picked).
- `StoryProductCartAdded` — add-to-cart interaction reported for analytics.
- `StoryProductCartAddFailed` — an add-to-cart attempt failed.
- `StoryCartButtonClicked` — the cart button was tapped.
- `StoryCartViewClicked` — the cart view was opened.
- `StoryCheckoutButtonClicked` — the checkout button was tapped.

### `StorylyProductDelegate.storylyUpdateWishlistEvent` (wishlist)

- `StoryWishlistAdded` — a product was added to the wishlist.
- `StoryWishlistRemoved` — a product was removed from the wishlist.
- `StoryWishlistFailed` — a wishlist operation failed (surfaced via the `onFail` result).

---

## Files

| File | Responsibility |
| --- | --- |
| `SegmentManager.swift` | Owns the shared `Analytics` instance; exposes `track` / `identify`. |
| `SegmentEventMapper.swift` | Maps Storyly objects to Segment `[String: Any]` properties. |
| `ViewController.swift` | Hosts the `StorylyView`; conforms to `StorylyDelegate` + `StorylyProductDelegate`. |
| `AppDelegate.swift` | Starts the SDK on launch via `SegmentManager.start()`. |

## Getting started

1. Open **`StorylyTwilioIntegrationSample.xcworkspace`** (not the `.xcodeproj`) in Xcode 15+.
2. Let Xcode resolve the Swift packages (File ▸ Packages ▸ Resolve Package Versions).
3. Put your Segment **write key** in `SegmentManager.swift` and your Storyly **instance token**
   in `ViewController.swift` (a public demo token is included so it runs as-is).
4. Select the `StorylyTwilioIntegrationSample` scheme + a simulator and Run. Interact with the
   stories and watch events land in your source's **Debugger** in the Segment dashboard.

## References

- [Analytics-Swift Implementation Guide (identify / track / reset)](https://www.twilio.com/docs/segment/connections/sources/catalog/libraries/mobile/apple/implementation)
- [Segment Track spec](https://www.twilio.com/docs/segment/connections/spec/track)
- [Segment Identify spec](https://www.twilio.com/docs/segment/connections/spec/identify)
- [Best practices for identifying users](https://segment.com/docs/connections/spec/best-practices-identify/)
- [Storyly iOS SDK](https://github.com/Netvent/storyly-ios)
