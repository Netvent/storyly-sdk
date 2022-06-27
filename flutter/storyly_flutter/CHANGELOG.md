### 1.22.1 (27.06.2022)
* added exported=false decleration to StorylyNotificationReceiver for countdown reminder for Android 31 support
* IMPORTANT! changed storyGroup:id and story:id fields' type to string

### 1.22.0 (20.06.2022)
* added support for 9:20 media assets
* added storylyUserProperty field
* added storylyShareUrl field for customized share urls
* added name and currentTime field to Story object
* added comment interactive components

### 1.20.0 (26.3.2022)
* updated native sdk dependencies
* updated Android native project dependencies; compileSdkVersion and targetSdk to 31

### 1.19.1 (21.2.2022)
* fixed scrolling issue that occurs if StorylyView is used inside nested scrolling views

### 1.19.0 (21.1.2022)
* added thematic product tag component for interactive stories

### 1.18.2 (6.1.2022)
* added storyGroupTextSize and storyGroupTextLines fields for story group title text customizations

### 1.18.1 (30.11.2021)
* implemented Android plugin using [Hybrid Composition](https://github.com/flutter/flutter/wiki/Hybrid-Composition), for details check [Hosting native Android and iOS views in your Flutter app with Platform Views](https://docs.flutter.dev/development/platform-integration/platform-views)

### 1.18.0 (26.11.2021)
* added promo code for interactive stories
* fixed unexpeted story group transitions issue
* IMPORTANT! added dataSource field to storylyLoaded callback

### 1.17.0 (25.10.2021)
* added image cta component for interactive stories
* added play modes handling for [openStoryUri method](https://github.com/Netvent/storyly-mobile/blob/master/flutter/storyly_flutter/lib/storyly_flutter.dart#L229), check for available modes from [Play Modes for Deep Links](https://integration.storyly.io/ios/deep-linking.html#play-modes)
* added RTL support
* removed XLarge default style on story group size
* added previous story group automatic swipe when previous click on first story
* fixed storylyEvent callback issue, [#136](https://github.com/Netvent/storyly-mobile/issues/136)

### 1.13.1 (13.08.2021)
* updated native sdk dependencies

### 1.13.0
* added setExternalData method for personalized content, check [Integrations with Personalization Platforms](https://integration.storyly.io/flutter/integrations.html#personalization-platforms)

### 1.12.0
* added null support to package
* added storyGroupIconImageThematicLabel field to StorylyParam to show dark/light story group icons, check [Thematic Story Group Icon](https://integration.storyly.io/flutter/ui-customizations.html#story-group-thematic-icon-image)

### 1.11.1
* added isTestMode field to StorylyParam to show test story groups, check [Test Mode](https://integration.storyly.io/flutter/test-mode.html)

### 1.11.0
* added image component for interactive stories
* added video component for interactive stories
* IMPORTANT! removed advertising id(idfa compatibility for iOS 14.5) usage

### 1.10.1
* updated native dependencies

### 1.10.0
* added product tag component for interactive stories
* improved story area usage
* fixed pinned story groups ordering

### 1.9.2
* added documentation
* updated flutter version to 1.20.0

### 1.9.1
* added 'storylyBackgroundColor' parameter
* fixed scrolling issue that occurs if StorylyView is used inside SingleChildScrollView

### 1.9.0
* added Interactive VOD feature
* added vertical, horizontal and custom placement support for emoji component
* fixed color parsing issue 
* fixed lag issue that occurs during scroll on iOS platform

### 1.8.6
* fixed ios methods not affecting bug

### 1.8.5
* added 'storylyEvent' callback
* added 'seen' field to StoryGroup and Story

### 1.8.4
* added 'storyGroupListEdgePadding' and 'storyGroupListPaddingBetweenItems' fields

### 1.8.3
* added close button to story header
* added 'storyHeaderCloseButtonIsVisible' parameter

### 1.8.2
* fixed crash related to missing permission 
* updated android's compiledSdkVersion to 30

### 1.8.1
* fixed default background color bug

### 1.8.0
* added poll, quiz, emoji, countdown, rating interactive components
* added share feature to stories
* added 'small', 'large', 'xlarge', 'custom' story group sizes
* added 'storylyUserInteracted' callback
* removed close button from stories
* added language support for en, tr, de, fr, ru, es locales
* added 'openStory' methods to open stories by programmatically

### 1.1.0
* added interactive stories support for custom button action, text and emoji reaction

## 0.0.2
* updated native versions

## 0.0.1
* initial release
