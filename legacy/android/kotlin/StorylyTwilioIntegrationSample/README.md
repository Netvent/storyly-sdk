# Storyly × Twilio Segment Integration (Android)

A minimal Kotlin/UIKit-style sample that shows how to forward **Storyly** events to
**Twilio Segment** using Segment's [analytics-kotlin](https://github.com/segmentio/analytics-kotlin)
SDK. Every story, interactive, and commerce event Storyly emits is mapped to a Segment
`track` call, and the user is tied to their activity with an `identify` call.

This is the Android counterpart of the iOS `StorylyTwilioIntegrationSample`.

- View-based Android app (`compileSdk 33`, `minSdk 24`), Storyly **4.19.0** and
  analytics-kotlin **1.25.0** added via Gradle.
- A public demo token so stories load out of the box.
- Segment wiring lives in three files: `SegmentManager.kt`, `SegmentEventMapper.kt`,
  and `MainActivity.kt`.

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

1. **Add the SDKs (Gradle).** In `app/build.gradle`:

   ```groovy
   implementation 'com.appsamurai.storyly:storyly:4.19.0'
   implementation 'com.segment.analytics.kotlin:android:1.25.0'
   ```

2. **Configure the Segment client.** `SegmentManager` owns a single shared `Analytics`
   instance. Replace `WRITE_KEY` with your source's write key (Segment dashboard >
   Connections > Sources > *your source* > Settings > API Keys).

   ```kotlin
   analytics = Analytics(WRITE_KEY, context) {
       trackApplicationLifecycleEvents = true  // Application Opened / Installed / Updated
       flushAt = 3                              // flush after 3 queued events
       flushInterval = 10                       // …or at least every 10s
   }
   ```

3. **Wire the listeners.** In `MainActivity.onCreate()` the Activity is set as both
   `storylyView.storylyListener` (story events) and `storylyView.storylyProductListener`
   (commerce events).
4. **Map and send.** Each listener callback builds a properties map with
   `SegmentEventMapper` and hands it to `SegmentManager`.

`SegmentManager` exposes thin wrappers over the SDK:

| Wrapper | Calls | Purpose |
| --- | --- | --- |
| `track(event, properties)` | `analytics.track(name, properties)` | One user action; the Storyly event name is the Segment event name. |
| `identify(userId, traits)` | `analytics.identify(userId, traits)` | Ties subsequent events to a known user. |

Because analytics-kotlin represents properties as a `JsonObject`, `SegmentManager`
converts the plain `Map<String, Any?>` produced by the mapper into a `JsonObject`
(recursively handling nested maps and lists) before each call.

Data flow:

```
StorylyView ──(listener callback)──▶ MainActivity
                                        │  builds properties map
                                        ▼
                                 SegmentEventMapper  ──▶ Map<String, Any?>
                                        │
                                        ▼
                                  SegmentManager  ──▶ analytics.track / identify
                                        │
                                        ▼
                                   Twilio Segment  ──▶ downstream destinations
```

In this sample:

- `storylyLoaded(...)` → `SegmentManager.identify("demo-user-123", traits)`
- every event callback → `SegmentManager.track(event.name, properties)`

---

## 3. Identify and anonymous ID generation in Twilio Segment

**Anonymous ID (automatic).** On first launch the Segment SDK generates an `anonymousId`
(a UUID) and persists it on disk. Every `track` and `identify` call automatically carries
this `anonymousId`, so you collect activity **before** you know who the user is. Because
it's device-persisted, the same anonymous visitor stays stable across app launches.

**Identify (tying activity to a user).** When you call:

```kotlin
SegmentManager.identify("demo-user-123", mapOf(
    "name" to "Demo User",
    "email" to "demo.user@example.com",
    "plan" to "free"
))
```

Segment writes that `userId` to disk and attaches it to every subsequent event. Segment
can then stitch the earlier anonymous activity to the identified user, and — because the
`userId` is your own stable identifier — connect the same user across devices. `traits` are
optional attributes about the user (name, email, plan, …).

In this sample `identify` is called from `storylyLoaded` with a **dummy** user; replace it
with your real user id and traits in production. If you have no user id yet, you can send
only traits, and events continue under the `anonymousId`.

**Resetting on logout.** Call `analytics.reset()` when a user logs out. It clears the stored
`userId`/traits, and a **new** `anonymousId` is generated afterwards — so the next session
isn't attributed to the previous user.

**Custom anonymous IDs (optional).** If you need to control the value, supply an
`anonymousIdGenerator` in the `Analytics` configuration instead of relying on Segment's
default UUID.

---

## 4. What does the event mapper do?

`SegmentEventMapper` is a **pure, stateless transformer** (a Kotlin `object` with only
functions) that converts the objects Storyly hands back in its listener callbacks into a
single `Map<String, Any?>` suitable for Segment `track` properties.

Key behaviors:

- **Nested shape that mirrors the domain.** The story group, story, and interactive
  component each become a nested sub-map; repeated objects (products, variants, colors)
  become nested lists.
- **Full property coverage.** It reads every public property of `StoryGroup` (plus its
  `style`/`badge`), `Story`, all interactive `StoryComponent` subclasses, and the commerce
  types `STRCart`, `STRCartItem`, `STRProductItem`, `STRProductVariant`.
- **Casts subclasses.** `StoryComponent` is an open base class; the mapper uses a `when (…)
  { is StoryQuizComponent -> … }` to pull out each concrete type's fields (quiz, image quiz,
  poll, emoji, rating, promo code, comment, swipe, button, product card/tag/catalog).
- **Normalizes values.** `@ColorInt` colors → `#AARRGGBB` hex strings, and optional values
  are simply omitted when `null`. `SegmentManager` then converts the map to a `JsonObject`.

Entry points:

| Function | Used for | Produces (top-level keys) |
| --- | --- | --- |
| `properties(event, storyGroup, story, storyComponent)` | Story & interactive events | `event`, `event_raw_value`, `story_group`, `story`, `component` |
| `cartProperties(event, cart, change)` | Cart events | `event`, `event_raw_value`, `cart`, `change` |
| `wishlistProperties(event, item)` | Wishlist events | `event`, `event_raw_value`, `product` |

`event_raw_value` is the `StorylyEvent` enum ordinal; `event` is `StorylyEvent.name`.

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

## 5. Which listener functions send events?

Storyly emits events through **two** listeners. Set both on the `StorylyView`:

```kotlin
storylyView.storylyListener = this        // StorylyListener — story & interactive events
storylyView.storylyProductListener = this // StorylyProductListener — commerce events
```

### 5.1 `StorylyListener.storylyEvent` — the main event stream

```kotlin
override fun storylyEvent(
    storylyView: StorylyView,
    event: StorylyEvent,
    storyGroup: StoryGroup?,
    story: Story?,
    storyComponent: StoryComponent?
)
```

| Parameter | Type | Description |
| --- | --- | --- |
| `storylyView` | `StorylyView` | The view instance that produced the event. |
| `event` | `StorylyEvent` | The event type; `event.name` gives its name. |
| `storyGroup` | `StoryGroup?` | The story group the event relates to, if any. |
| `story` | `Story?` | The story the event relates to, if any. |
| `storyComponent` | `StoryComponent?` | The interactive component involved, if the event is component-related. |

Use this for **all non-commerce events**. Map with `SegmentEventMapper.properties(...)`.

### 5.2 `StorylyProductListener.storylyUpdateCartEvent` — cart mutations

```kotlin
override fun storylyUpdateCartEvent(
    storylyView: StorylyView,
    event: StorylyEvent,
    cart: STRCart?,
    change: STRCartItem?,
    onSuccess: ((STRCart?) -> Unit)?,
    onFail: ((STRCartEventResult) -> Unit)?
)
```

| Parameter | Type | Description |
| --- | --- | --- |
| `storylyView` | `StorylyView` | The view instance that produced the event. |
| `event` | `StorylyEvent` | The cart event type (add / update / remove). |
| `cart` | `STRCart?` | Snapshot of the cart (items, total price, currency). |
| `change` | `STRCartItem?` | The single item being added/updated/removed. |
| `onSuccess` | `((STRCart?) -> Unit)?` | Invoke to confirm the change succeeded; return the updated cart. |
| `onFail` | `((STRCartEventResult) -> Unit)?` | Invoke to report failure with a message. |

You **must** invoke `onSuccess` (or `onFail`) so the Storyly UI can proceed. Map with
`SegmentEventMapper.cartProperties(...)`. In a real app, apply the change to your own cart
and pass the updated `STRCart` to `onSuccess`.

### 5.3 `StorylyProductListener.storylyUpdateWishlistEvent` — wishlist changes

```kotlin
override fun storylyUpdateWishlistEvent(
    storylyView: StorylyView,
    item: STRProductItem?,
    event: StorylyEvent,
    onSuccess: ((STRProductItem?) -> Unit)?,
    onFail: ((STRWishlistEventResult) -> Unit)?
)
```

| Parameter | Type | Description |
| --- | --- | --- |
| `storylyView` | `StorylyView` | The view instance that produced the event. |
| `item` | `STRProductItem?` | The product being added to / removed from the wishlist. |
| `event` | `StorylyEvent` | The wishlist event type (added / removed). |
| `onSuccess` | `((STRProductItem?) -> Unit)?` | Invoke to confirm the change; return the product. |
| `onFail` | `((STRWishlistEventResult) -> Unit)?` | Invoke to report failure with a message. |

Map with `SegmentEventMapper.wishlistProperties(...)`, then invoke `onSuccess`/`onFail`.

### 5.4 `StorylyProductListener.storylyEvent` — remaining commerce events

```kotlin
override fun storylyEvent(storylyView: StorylyView, event: StorylyEvent)
```

| Parameter | Type | Description |
| --- | --- | --- |
| `storylyView` | `StorylyView` | The view instance that produced the event. |
| `event` | `StorylyEvent` | The commerce event type (no story context is provided here). |

This fires for product events that are neither cart mutations nor wishlist updates (e.g.
product sheet opened, checkout tapped). It is a distinct overload from the main listener's
`storylyEvent` (two parameters vs five), so both coexist on the same class. Map with
`SegmentEventMapper.properties(event, null, null, null)`.

> `StorylyProductListener` also declares `storylyHydration(storylyView, products)`. It is
> **not** an analytics event — Storyly calls it to request full product data for the product
> IDs found in your stories. Handle it by supplying your catalog data, not by tracking.

---

## 6. Related events per listener function

Storyly routes each `StorylyEvent` to exactly one of the callbacks above, so tracking in all
of them gives full coverage with no double-counting.

### `StorylyListener.storylyEvent` (story & interactive)

- **Story group:** `StoryGroupOpened`, `StoryGroupUserOpened`, `StoryGroupDeepLinkOpened`,
  `StoryGroupProgrammaticallyOpened`, `StoryGroupCompleted`, `StoryGroupPreviousSwiped`,
  `StoryGroupNextSwiped`, `StoryGroupClosed` — how users enter, move through, and leave groups.
- **Story playback:** `StoryImpression`, `StoryViewed`, `StoryCompleted`,
  `StoryPreviousClicked`, `StoryNextClicked`, `StoryPaused`, `StoryResumed`, `StorySeeked`,
  `StoryShared`, `StoryLiked` — per-story viewing and playback behavior.
- **Interactive components:** `StoryCTAClicked`, `StoryButtonActionClicked`,
  `StoryImageButtonActionClicked`, `StorySwipeActionClicked`, `StoryEmojiClicked`,
  `StoryPollAnswered`, `StoryQuizAnswered`, `StoryImageQuizAnswered`, `StoryRated`,
  `StoryCountdownReminderAdded`, `StoryCountdownReminderRemoved`, `StoryPromoCodeCopied`,
  `StoryCommentSent`, `StoryCommentInputOpened`, `StoryCommentInputClosed`,
  `StoryProductTagExpanded`, `StoryProductTagClicked`, `StoryProductCardClicked`,
  `StoryProductCatalogClicked` — reactions to and clicks on interactive layers (including
  product tag/card/catalog clicks).
- **Bar:** `StorylyBarImpression` — the story bar became visible with new content.

### `StorylyProductListener.storylyUpdateCartEvent` (cart mutations)

- `StoryProductAdded` — a product was added to the cart.
- `StoryProductUpdated` — a cart line item changed (e.g. quantity).
- `StoryProductRemoved` — a product was removed from the cart.

These carry the `cart` and `change` context and expect an `onSuccess`/`onFail` response.

### `StorylyProductListener.storylyEvent` (other commerce events)

- `StoryProductSheetOpened` — the product detail sheet was opened.
- `StoryProductSelected` — a product was selected (e.g. a variant/product picked).
- `StoryProductCartAdded` — add-to-cart interaction reported for analytics.
- `StoryProductCartAddFailed` — an add-to-cart attempt failed.
- `StoryCartButtonClicked` — the cart button was tapped.
- `StoryCartViewClicked` — the cart view was opened.
- `StoryCheckoutButtonClicked` — the checkout button was tapped.

### `StorylyProductListener.storylyUpdateWishlistEvent` (wishlist)

- `StoryWishlistAdded` — a product was added to the wishlist.
- `StoryWishlistRemoved` — a product was removed from the wishlist.
- `StoryWishlistFailed` — a wishlist operation failed (surfaced via the `onFail` result).

---

## Files

| File | Responsibility |
| --- | --- |
| `SegmentManager.kt` | Owns the shared `Analytics` instance; exposes `track` / `identify`; converts maps to `JsonObject`. |
| `SegmentEventMapper.kt` | Maps Storyly objects to a nested `Map<String, Any?>`. |
| `MainActivity.kt` | Hosts the `StorylyView`; implements `StorylyListener` + `StorylyProductListener`. |
| `Tokens.kt` | Holds the Storyly instance token (public demo token by default). |

## Getting started

1. Open the `StorylyTwilioIntegrationSample` folder in Android Studio.
2. Let Gradle sync resolve the dependencies.
3. Put your Segment **write key** in `SegmentManager.kt` and (optionally) your Storyly
   **instance token** in `Tokens.kt` (a public demo token is included so it runs as-is).
4. Run the `app` configuration on a device/emulator, interact with the stories, and watch
   events land in your source's **Debugger** in the Segment dashboard.

> Dependency versions (Storyly `4.19.0`, analytics-kotlin `1.25.0`, AGP `7.4.0`,
> Kotlin `1.9.22`, Gradle `7.5`) are a known-good baseline; bump them to the latest as
> needed. Storyly 4.19.0 is built with Kotlin 1.9, so the Kotlin plugin must be `1.9.x` or
> newer — an older Kotlin (e.g. 1.7) fails with an "incompatible metadata version" error.

## References

- [Analytics-Kotlin (Android)](https://www.twilio.com/docs/segment/connections/sources/catalog/libraries/mobile/kotlin-android)
- [Analytics-Swift/Kotlin Implementation Guide (identify / track / reset)](https://www.twilio.com/docs/segment/connections/sources/catalog/libraries/mobile/apple/implementation)
- [Segment Track spec](https://www.twilio.com/docs/segment/connections/spec/track)
- [Segment Identify spec](https://www.twilio.com/docs/segment/connections/spec/identify)
- [Storyly Android SDK](https://github.com/Netvent/storyly-android)
