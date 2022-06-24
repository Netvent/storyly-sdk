# Release Notes
### 1.23.3 (24.06.2022)
* fixed ANR issue on older Android devices

### 1.23.2 (20.06.2022)
* IMPORTANT! changed story:id and storyGroup:id field to string
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
