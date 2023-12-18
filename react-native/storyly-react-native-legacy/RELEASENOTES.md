# Release Notes
* If you are using new Fabric architecture please use these [Fabric supported versions](https://github.com/Netvent/storyly-mobile/blob/master/react-native/storyly-react-native/RELEASENOTES.md) of storyly-react-native.

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
