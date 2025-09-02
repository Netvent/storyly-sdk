# Release Notes
* If you are using new Fabric architecture please use [storyly-react-native-fabric](https://github.com/Netvent/storyly-mobile/blob/master/react-native/storyly-react-native-fabric/RELEASENOTES.md) package.
### 4.17.0 (02.09.2025)
* updated dependencies for React 19
* improved view hierarchy of the story screen on ios platform

### 4.16.3 (14.08.2025)
* fixed a bug related to visible story group tracking on android platform
* fixed a bug related to image group cover reset on android platform
* improved memory management for widget gallery on android platform
* fixed audio session handling for storyly on ios platform
* fixed pause/resume flow after closing bottom sheet for vertical feed on ios platform

### 4.16.2 (11.07.2025)
* improved interactive component add/remove flow on android platform
* fixed a bug related to scrolling in product detail sheet for vertical feed on android platform

### 4.16.0 (23.06.2025)
* improved orientation changes for large screens by covering Android 16 changes on android platform
* improved countdown interactive component alarm schedule as exact on android platform
* fixed audio session handling for video covers on ios platform
* improved audio session handling for video stories on ios platform
* fixed a bug related to bar styling changes on initialization on ios platform

### 4.15.1 (27.05.2025)
* fixed a bug related to Inter fonts on ios platform
* fixed a bug related to Storyly views when a Picture-in-Picture activity is active on android platform

### 4.15.0 (16.05.2025)
* fixed a bug related to story group title custom font size
* fixed a bug related to scrapped and detached views in StorylyBar on android platform
* fixed a bug related to story header icon visibility on android platform
* changed emoji library to emoji2 on android platform
* fixed a bug related to energized group badges on ios platform

### 4.14.1 (15.05.2025)
* improved event types for storyly load failed and story open failed

### 4.14.0 (30.04.2025)
* IMPORTANT! renamed openStory function for Vertical Feed
* fixed nullable string cast issue for latest versions of react native
* fixed a bug related to dark cover update for custom styling
* fixed a bug related to swipe interactive component animationg on ios platform
* fixed a memory leak related to video covers on ios platform
* fixed wishlist icon visibility for static product catalog interactive component on ios platform
* fixed a bug related to timed interactive animations on android platform
* added StoryImageQuizComponent
* added play and pause function for VerticalFeedPresenter
* added data cache invalidation for customParameter changes
* added VerticalFeedBarImpression as a public Vertical Feed event
* improved asset load mechanism by prioritizing app bundle on ios platform
* improved interactive component initial animations for prefetched stories on ios platform

### 4.12.2 (03.04.2025)
* fixed a bug related to custom group styling events on ios platform

### 4.12.1 (24.03.2025)
* added product wishlist support for product catalog component and product detail sheet
* added StorylyBarImpression as a public Storyly event
* improved iconUrl of StoryGroup by providing dark theme url
* fixed a bug related to re-addition of product card interactive component on android platform
* fixed a bug related to border color of rating interactive component on ios platform
* fixed a bug related to keyboard focus of comment interactive component on ios platform

### 4.11.0 (05.03.2025)
* added accessibility fields for Turkish
* added support for single response comment interactive component
* improved story description accessibility field for English and Hebrew
* improved quiz interactive component with enabled/disabled percentage information
* improved image quiz interactive component with enabled/disabled percentage information
* improved poll interactive component with enabled/disabled percentage information
* improved emoji interactive component with enabled/disabled percentage information
* improved rating interactive component with enabled/disabled average answer information
* decreased animation duration for quiz, image quiz and emoji interactive components
* adapted edge-to-edge display to Storyly for android >= 35 on android platform
* adapted edge-to-edge display to Vertical Feed for android >= 35
* fixed a bug related opacity of image quiz interactive component on android platform
* fixed a crash related to countdown interactive component on android platform
* fixed a crash related to video cache on ios platform
* fixed layout issues on iPad devices for Storyly  on ios platform

### 4.10.1 (24.02.2025)
* added missing localization fields for Hebrew

### 4.10.0 (18.02.2025) 
* improved vertical feed loading and rendering flow
* added framework information for analytical purposes
* added support for tap and go groups
* fixed a visual bug related to play button for vertical feed on android platform
* fixed a bug related to StorylyView edge padding on android platform
* fixed resizing of CTA button of product bottom sheet on android platform
* improved failure recovery for analytic requests on android platform
* improved interactive component initial animations for prefetched stories on android platform  
* fixed a bug related to story group/story transitions when voiceover is enabled on ios platform
* fixed a bug related to RTL layouts for storyly and vertical feed on ios platform
* fixed a bug related to scroll behavior of VerticalFeedPresenterView on ios platform

### 4.8.0 (17.01.2025)
* IMPORTANT! fixed crash related to widget style on android platform
* improved story rendering while transitioning between stories
* improved skeleton view rendering flow
* fixed areas for next/previous clicks for RTL layouts

### 4.7.1 (04.02.2025)
* fixed a bug related to openStory for sg play mode

### 4.7.0 (13.01.2025)
* added vertical feed
* added config for pin icon visibility
* added dynamic cover size option for pinned story groups
* added config for app logo visibility for shared media
* improved areas for next/previous clicks

### 3.11.0 (13.12.2024)
* added local data cache invalidation on minor and major sdk version change
  
### 3.10.0 (05.12.2024)
* added video share to Instagram Stories
* added customPayload to the missing layer types
* added RTL support to share bottom sheet
* added related storyComponents to Storyly delegate and listener methods
* fixed a bug related to product bottom sheet image load on android platform, fixed [#392](https://github.com/Netvent/storyly-mobile/issues/392)
* fixed a bug related to conditional stories on android platform

### 3.8.1 (15.11.2024)
* IMPORTANT! renamed products field to actionProducts in Story class
* added new public interactive component types
* improved StorylyView initialization flow
* fixed a bug related to style changes
* added video cache for video stories
* improved interactive component add/remove flow on android platform
* improved activity assignment flow in StorylyView on android platform

### 3.6.3 (31.10.2024)
* improved data processing flow on android platform
* improved memory usage of gif media on ios platform
* improved synchronization between video story media and header on ios platform
* improved AVAudioSession category changes on ios platform

### 3.6.2 (01.10.2024)
* fixed missing product url on android platform

### 3.6.1 (17.09.2024)
* fixed a nullability issue

### 3.6.0 (09.09.2024)
* added story bar instance settings
* fixed a bug related to IllegalStateException on android platform
* fixed a bug related to Storyly load on android platform
* fixed a bug related to click action analytics on android platform
* improved story header icon background on android platform
* improved layout of story group and header icon on android platform
* fixed bug related to interactive component interaction on ios platform

### 3.4.1 (12.08.2024)
* fixed a positioning bug related to custom styling

### 3.4.0 (29.07.2024)
* added out of stock handling for product related interactive components

### 3.3.0 (29.07.2024)
* added video covers for story groups
* fixed a bug related to device orientation for tablets on android platform
* fixed instagram store id for share sheet on ios platform

### 3.2.1 (22.07.2024)
* improved storyly widget related analytic events
* improved story group visibility related analytic events
* improved missing monetization fields handling
* changed logo and text of Twitter to X on share sheet
* improved story share handling for missing social apps on ios platform

### 3.2.0 (01.07.2024)
* added sponsored story group feature
* added style field to StoryGroup interface

### 3.1.1 (28.06.2024)
* fixed a bug related to custom styling

### 3.1.0 (13.06.2024)
* improved story group cover selection flow with focal points
* improved missing product handling by filtering stories
* fixed a typo in portuguese translation on android platform

### 3.0.1 (30.05.2024)
* improved monetization templates on ios platform

### 3.0.0 (24.05.2024)
* improved load time of the Storyly Widget
* removed Storyly Moments
* IMPORTANT! removed StoryMedia class and media field from public Story class
* IMPORTANT! added previewUrl, actionUrl and storyComponentList to the public Story class

### 2.18.1 (22.05.2024)
* added key field for product variants to indicate variant type
* fixed a visual bug for poll and quiz interactive components on android platform

### 2.18.0 (13.05.2024)
* improved placement of product tag interactive component based on content
* improved payload of product events
* fixed storylyStoryDismissed delegate trigger time on ios platform
* fixed an issue related to product payload of story impression events on android platform
* improved monetization templates on android platform

### 2.17.3 (06.05.2024)
* improved usage of actionUrl and products in storylyActionClicked callback
* fixed an issue related to visibility of the product catalog interactive component on android platform

### 2.17.2 (25.04.2024)
* fixed a bug related to analytics requests on ios platform

### (DEPRECATED) 2.17.1 (24.04.2024)
* fixed thumbnail image load issue of video stories
* fixed story dismiss issue after a non-modal view controller presented over stories on ios platform
* fixed a bug related to cta behavior of product related interactive components on android platform
* fixed icon corner radius flick on fragment transitions on android platform
* fixed a bug related to icon corner radius on android 8 and below devices on android platform

### (DEPRECATED) 2.17.0 (08.04.2024)
* fixed RTL support issues for product related interactive components
* fixed bugs related to conditional stories
* added additional bottom sheet customizations for product related interactive components
* improved bottom sheet functionality for product related interactive components
* improved StorylyDataSource by simplifying the sources for storylyLoaded callback
* improved network requests on android platform
* fixed a bug related to product sheet colors on android platform
* added privacy manifest files for the upcoming SDK requirements on ios platform

### 2.16.1 (19.03.2024)
* improved price formatting for product related interactive components
* fixed a bug related to interactive component representation
* improved action flow for product related interactive components
* improved analytic events

### 2.15.0 (27.02.2024)
* improved media url handling
* improved functionality of product catalog interactive component
* fixed a bug related to product cart state

### 2.14.0 (19.02.2024)
* added animations for text interactive component
* improved functionality and design of story group countdown badge
* improved data processing flow
* added video position/resize handling
* added static inputs for product catalog interactive component
* fixed a bug related to scroll position in storyly bar on android platform
* fixed an orientation bug for devices having iOS version <16 on ios platform

### 2.4.9 (17.01.2024)
* fixed data structure of onPress event

### 2.4.8 (12.01.2024)
* fixed a bug related to custom group styling

### 2.4.7 (11.01.2024)
* fixed a bug related to simulator architecture on ios platform

### 2.4.6 (09.01.2024)
* IMPORTANT! increased minimum os version to 12 on ios platform; please refer to [Xcode 15 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes)

### 2.4.5 (27.12.2023)
* improved data cache flow
* fixed a bug related to conditional stories flow
* added background image position/resize handling
* fixed IllegalStateException during activity recreation on android platform
* fixed a ui bug related to outlineProvider on android platform
* changed storyly-exoplayer2 dependency to 2.18.1-1 on android platform
* fixed a bug related to story group size on android platform

### 2.4.4 (18.12.2023)
* IMPORTANT! changed type of products parameter onProductHydration callback
* added nudge stories
* improved data update flow of story bar 
* fixed a bug related to conditional stories flow
* optimized memory management of SDWebImage on ios platform

### 2.4.3 (06.12.2023)
* IMPORTANT! added storylyLocale property for localization; please refer to [Localization documentation](https://docs.storyly.io/docs/ios-initial-sdk-setup#localization)
* IMPORTANT! removed storyProductCountry and storyProductLanguage properties; please use storylyLocale property
* added animation for not-fitting images in automated shoppable image layers
* added storyProductFeed property for client side automated shoppable stories
* improved story screen reset flow on android platform

### 2.4.2 (16.11.2023)
* improved story bar scrolling after data update
* changed storyId parameter to nullable for openStoryWithId function 
* fixed a bug related to group select on android platform

### 2.4.1 (09.11.2023)
* added improvements for text interactive components
* optimized story dismiss flow
* optimized memory usage on android platform
* fixed a visual bug in quiz interactive component on android platform
* fixed a visual bug in countdown interactive component on ios platform

### 2.4.0 (29.09.2023)
* added gif support for story group covers
* added multi region and language support for product feeds

### 2.3.1 (22.09.2023)
* optimized memory usage
* improved layout on orientation change

### 2.3.0 (09.09.2023)
* added support for google fonts from Storyly studio for text interactive component
* added support for instance theme settings from Storyly dashboard
* added Live story group type to support streaming urls
* converted emoji interactive component results from click counts to percentages

### 2.2.1 (24.08.2023)
* added types for product flow objects and functions

### 2.2.0 (24.08.2023)
* IMPORTANT! increased minimum os version to 11 on ios platform; please refer to [Xcode 14 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes)
* IMPORTANT! removed armv7 and i386 arch support on ios platform; please refer to [Xcode 14 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes)
* IMPORTANT! removed bitcode support on ios platform; please refer to [Xcode 14 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes)
* IMPORTANT! deprecated open and close methods
* IMPORTANT! added closeStory, pauseStory and resumeStory methods
* added cart synchronization support and callbacks for product flow
* reduced framework size on ios platform
* changed sound volume behavior for video stories on ios platform
* fixed a bug related to group select on android platform

### 2.1.0 (17.08.2023)
* added result interactive components for poll, quiz, reaction, image quiz, rating, question
* added animation feature to interactive components entrance 
* added story group countdown badge

### 2.0.1 (02.08.2023)
* added storylyFacebookAppID 
* fixed [#293](https://github.com/Netvent/storyly-mobile/issues/293)

### 2.0.0 (24.07.2023)
* migrated native version to 2.0

### 1.33.5 (29.05.2023)
* removed onProductEvent

### 1.33.4 (05.05.2023)
* added hydrateProducts methods
* added onProductHydration and onProductEvent callbacks

### 1.33.3 (04.05.2023)
* fixed storyItemProgressBarColor and storyItemIconBorderColor for iOS side

### 1.33.2 (26.04.2023)
* improved StorylyView initalization flow on native sides

### 1.33.1 (17.04.2023)
* added logs to ios bridge side

### 1.33.0 (03.04.2023)
* updated react dependencies to 18.x.x
* added prop-types as dependency

### 1.32.5 (06.04.2023)
* reduced logs in ios bridge side
* added StoryGroupListStyling properties (reverted temporary removal) 

### 1.32.4 (04.04.2023)
* added logs to ios bridge side

### 1.32.3 (04.04.2023)
* removed StoryGroupListStyling properties (temporary) 

### 1.32.2 (04.04.2023)
* added logs to ios bridge side

### 1.32.1 (03.04.2023)
* removed JSX import 
* added logs to ios bridge side

### 1.32.0 (28.03.2023)
* added product catalog interactive component
* improved activity change handling on android side

### 1.31.0 (06.03.2023)
* added image quiz interactive component
* added color option to poll interactive component
* added like/view analytics buttons for Moments story groups
* added local cache invalidation flow 
* added etag implementaion
* improved data manager queue flow

### 1.30.1 (15.02.2023)
* fixed storyGroupSize not working bug

### 1.30.0 (01.02.2023)
* added product card interactive component
* added like/dislike feature for emoji interactive component
* changed design of the emoji interactive component
* added vertical/horizontal grid layout support
* IMPORTANT! removed storyGroupListEdgePadding and storyGroupListPaddingBetweenItems
* IMPORTANT! added storyGroupListOrientation, storyGroupListSections, storyGroupListHorizontalEdgePadding, storyGroupListVerticalEdgePadding, storyGroupListHorizontalPaddingBetweenItems and storyGroupListVerticalPaddingBetweenItems

### 1.29.1 (10.01.2023)
* fixed [#256](https://github.com/Netvent/storyly-mobile/issues/256)

### 1.29.0 (09.01.2023)
* IMPORTANT! changed design of swipe interactive component
* IMPORTANT! updated Xcode version to 13.2.1 for builds
* fixed storyGroup:iconUrl format for user generated content

### 1.28.1 (19.12.2022)
* fixed a bug that labels are not working on iOS platform

### 1.28.0 (13.12.2022)
* IMPORTANT! added story group animation to borders, use storyGroupAnimation field to disable
* added past date information of story to header for moments story groups
* added localization(pt) support

### 1.27.1 (10.11.2022)
* fixed [#247](https://github.com/Netvent/storyly-mobile/issues/247)

### 1.27.0 (08.11.2022)
* added STStorylyGroupViewFactory and STStorylyGroupView to support customized story list views
* added link cta interactive component

### 1.26.2 (11.10.2022)
* improved native dependency handling to support Monetization by Storyly

### 1.26.1 (25.08.2022)
* improved react-native@0.69 support

### 1.26.0 (24.08.2022)
* added StoryComponent implementations
* added storyGroupTextTypeface, storyItemTextTypeface and storyInteractiveTextTypeface to support custom fonts
* added storyHeaderCloseIcon and storyHeaderShareIcon to support customazible icons
* added storylyPayload for Storyly Moments usage
* fixed [#210](https://github.com/Netvent/storyly-mobile/issues/210)

### 1.24.1 (31.07.2022)
* IMPORTANT! added storyGroupTextColorSeen and storyGroupTextColorNotSeen fields
* IMPORTANT! removed storyGroupTextColor field
* IMPORTANT! added storylyLayoutDirection field
* fixed [#202](https://github.com/Netvent/storyly-mobile/issues/202)

### 1.24.0 (08.07.2022)
* added swipe up designs with a/b test option
* added outlink parameter to countdown interactive component
* added application icon to countdown notification
* added accessibility features for navigation, story open/close, swipe/button/image cta interactive components
* fixed [#201](https://github.com/Netvent/storyly-mobile/issues/201)

### 1.23.4 (27.06.2022)
* added exported=false decleration to StorylyNotificationReceiver for countdown reminder for Android 31 support
* IMPORTANT! changed storyGroup:id and story:id fields' types to string

### 1.23.3 (24.06.2022)
* fixed ANR issue on older Android devices

### 1.23.2 (20.06.2022)
* IMPORTANT! changed openStory method parameter types to string

### 1.23.1 (09.06.2022)
* removed cdn fallback flow

### 1.23.0 (08.06.2022)
* updated Storyly Native SDK dependencies to 1.23 minor version
* added comment interactive components

### 1.22.1 (26.5.2022)
* changed Android compileSdk and targetSdk dependency to 31
* fixed [#182](https://github.com/Netvent/storyly-mobile/issues/182)

### 1.22.0 (23.5.2022)
* added storylyShareUrl field for customized share urls
* added name and currentTime field to Story object

### 1.21.2 (28.4.2022)
* changed Android compileSdk and targetSdk dependency to 30

### 1.21.0 (22.4.2022)
* added support for 9:20 media assets
* added storylyUserProperty field
* updated native sdk dependencies

### 1.20.1 (31.3.2022)
* updated react-native and react dependencies
* improved typescript support

### 1.20.0 (22.3.2022)
* updated Android native project dependencies, [React Upgrade Helper; from 0.64.2 to 0.67.3](https://react-native-community.github.io/upgrade-helper/?from=0.64.2&to=0.67.3), fixed [#151](https://github.com/Netvent/storyly-mobile/issues/151) and [#150](https://github.com/Netvent/storyly-mobile/issues/150)
* removed constraint for setting all field for ui customizations, fixed [#157](https://github.com/Netvent/storyly-mobile/issues/157)
* fixed [#166](https://github.com/Netvent/storyly-mobile/issues/166)
* fixed [#153](https://github.com/Netvent/storyly-mobile/issues/153) by updating ExoPlayer dependency to 2.17.1

### 1.19.2 (24.2.2022)
* added onStoryOpenFailed callback, check native documentation for details [StorylyStoryShowFailed Event](https://integration.storyly.io/android/deep-linking.html#storylystoryshowfailed-event) and [StorylyStoryPresentFailed Event](https://integration.storyly.io/ios/deep-linking.html#storylystorypresentfailed-event)

### 1.19.1 (23.2.2022)
* fixed story not opening bug when a user clicks a story group

### 1.19.0 (24.1.2022)
* added thematic product tag component for interactive stories
* fix StoryGroupTextStyling customization fields

### 1.18.1 (6.1.2022)
* added storyGroupTextSize and storyGroupTextLines fields for story group title text customizations

### 1.18.0 (2.12.2021)
* added promo code for interactive stories
* fixed unexpeted story group transitions issue
* IMPORTANT! added dataSource field to storylyLoaded callback

### 1.17.0 (25.10.2021)
* added image cta component for interactive stories
* added play modes handling for [openStory method](https://github.com/Netvent/storyly-mobile/blob/master/react-native/storyly-react-native/RNStoryly.js#L35), check for available modes from [Play Modes for Deep Links](https://integration.storyly.io/ios/deep-linking.html#play-modes)
* added RTL support
* removed XLarge default style on story group size
* added previous story group automatic swipe when previous click on first story

### 1.13.1 (13.08.2021)
* updated native sdk dependencies

### 1.13.0
* added setExternalData method for personalized content, check [Integrations with Personalization Platforms](https://integration.storyly.io/react-native/integrations.html#personalization-platforms)

### 1.11.1
* added isTestMode field to attributes to show test story groups, check [Test Mode](https://integration.storyly.io/react-native/test-mode.html)

### 1.11.0
* added image component for interactive stories
* added video component for interactive stories
* IMPORTANT! removed advertising id(idfa compatibility for iOS 14.5) usage

### 1.10.2
* fixed onUserInteracted's event type representation; "quiz", "poll", "emoji", "rating"
* fixed crash on quiz payload handling on iOS

### 1.10.1
* fixed custom size handling in iOS

### 1.10.0
* added product tag component for interactive stories
* improved story area usage
* fixed pinned story groups ordering

### 1.9.2
* added story group id and story id to data payloads
* fixed iOS view rendering bug during animation, [#69](https://github.com/Netvent/storyly-mobile/issues/69)

### 1.9.1
* fixed crash with onLoad callback

### 1.9.0
* added Interactive VOD feature
* added vertical, horizontal and custom placement support for emoji component
* fixed screen rendering issue on Android during animations

### 1.8.4
* improved screen rendering for seen/unseen feedback

### 1.8.3
* added 'onEvent' callback
* added 'seen' field to StoryGroup and Story payloads

### 1.8.1
* added 'storyHeaderCloseButtonIsVisible' field
* added 'storyGroupListEdgePadding' and 'storyGroupListPaddingBetweenItems' fields

### 1.8.0
* added countdown and rating component for interactive stories
* added share feature to stories
* added 'custom' story group size
* added 'storylyUserInteracted' callback
* added language support for en, tr, de, fr, ru, es locales
* added 'openStory' methods to open stories by programmatically
* added use_frameworks! constraint for iOS CocoaPods integrations
* removed close button from stories

### 1.6.0
* added quiz component for interactive stories
* removed use_frameworks! constraint for iOS CocoaPods integrations
* added 'xlarge' story group size
* added storyGroupIconForegroundColors method for 'xlarge' story groups gradient layer
* added 'customParameter' parameter to StorylyInit to pass customized field for users
* added interactive stories support for poll
* updated placement of emoji reaction view

### 1.3.1
* updated native Storyly SDK dependencies, Android to 1.4.1 and iOS to 1.3.*
* fixed setExternalData naming issue that causes compile time error
* fixed android crash that occur if initialization is done without segments information

### 1.3.0
* IMPORTANT! change storylyInit signature, please check README
* added setExternalData method to support customized data usage
* added openStory method to support deep linking

### 1.1.0
* add interactive stories support for custom button action, text and emoji reaction

### 1.0.0
* IMPORTANT! change onLoad callback signature, please check README
* IMPORTANT! change onFail callback signature, please check README
* add onStoryOpen and onStoryClose callbacks

### 0.0.18
* initial release
