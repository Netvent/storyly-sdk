# Release Notes
### 1.11.3
* updated PendingIntent handling to comply Android 12 security updates

### 1.11.2
* improved story group border thickness for low resolution devices

### 1.11.1
* added support external fragment usage, check [Fragment Overlay](https://integration.storyly.io/android/fragment-overlay.html)
* added isTestMode field to StorylyInit to show test story groups, check [Test Mode](https://integration.storyly.io/android/test-mode.html)

### 1.11.0
* added image component for interactive stories
* added video component for interactive stories
* IMPORTANT! removed advertising id usage
* IMPORTANT! removed url field from StoryMedia
* reduced memory signature

### 1.10.2
* fixed a rare crash occurs on older devices, [#74](https://github.com/Netvent/storyly-mobile/issues/74) and [#75](https://github.com/Netvent/storyly-mobile/issues/75)
* improved handling for a rare crash, [#85](https://github.com/Netvent/storyly-mobile/issues/85) and [#86](https://github.com/Netvent/storyly-mobile/issues/86)

### 1.10.0
* IMPORTANT! moved to mavenCentral from jCenter, please update dependencies accordingly
* added product tag component for interactive stories
* improved story area usage 
* fixed pinned story groups ordering 
* fixed a rare crash, [#76](https://github.com/Netvent/storyly-mobile/issues/76)

### 1.9.5
* fixed a rare crash, [#70](https://github.com/Netvent/storyly-mobile/issues/70)
* changed custom animation handling

### 1.9.4
* improved EmojiCompat handling for devices that doesn't contain Google APIs 

### 1.9.3
* fixed a bug that can cause a memory leak, [#62](https://github.com/Netvent/storyly-mobile/issues/62)

### 1.9.2
* added actionUrlList to Story data

### 1.9.1
* added support for interactive components without titles
* added animation to swipe up icon and text
* added thematic icon support for story groups
* added custom animation support for dismiss and show functions

### 1.9.0
* added Interactive VOD feature
* added vertical, horizontal and custom placement support for emoji component
* improved cube animation during transitions
* improved interactive layer rendering
* IMPORTANT! changed storylyActionClicked signature(removed return type)

### 1.8.9
* fixed a crash related with TextureView background usage for newer Android versions(api level 24+)

### 1.8.8
* improved story header animation during long press

### 1.8.7
* added story header animation during long press
* replace emoji-bundled with emoji-compat to reduce effect on apk size 
* fixed text mask/cut issue on poll component that occured on specific devices

### 1.8.6
* added storylyEvents method to StorylyListener
* added 'seen' field to StoryGroup and Story

### 1.8.5
* fixed integration error, [#42](https://github.com/Netvent/storyly-mobile/issues/42)

### 1.8.3
* fixed crash related to missing permission 
* updated android's compiledSdkVersion to 30

### 1.8.2
* fixed crash related obfuscation on custom loading view usage

### 1.8.1
* added 'setStoryItemTextTypeface' method to support custom font for story title
* added 'isCloseButtonVisible' attribute to StoryHeaderStyling and 'storyHeaderCloseButtonIsVisible' as xml attribute for visibility option of close button
* added 'showExternalActionView' and 'dismissExternalActionView' methods to support external custom view to show and dismiss while stories are being shown
* added 'storylyLoadingView' programmatic attribute to support external custom loading view instead of using default loading view

### 1.8.0
* added rating component for interactive stories
* added language support for en, tr, de, fr, ru, es locales

### 1.7.4
* added StoryGroupIconStyling to support custom size story groups, added 'storyGroupIconWidth', 'storyGroupIconHeight', 'storyGroupIconCornerRadius' and 'storyGroupPaddingBetweenItems' as xml attributes
* added StoryGroupTextStyling for visibility handling of elements, added 'storyGroupTextIsVisible' as xml attribute
* added StoryHeaderStyling for visibility handling of elements, added 'storyHeaderIconIsVisible', 'storyHeaderTextIsVisible' as xml attributes
* added runtime update feature for StorylyInit's segmentation parameters

### 1.7.3
* improved swipe up handling

### 1.7.2
* added storylyUserInteracted(storylyView: StorylyView, storyGroup: StoryGroup, story: Story, storyComponent: StoryComponent) callback
* improved events for better analysis

### 1.7.0
* added countdown component for interactive stories
* added share feature to stories
* removed close button from stories

### 1.6.3
* improved events for better analysis

### 1.6.2
* added thumbnail image to video stories
* improved event payload for better analysis

### 1.6.1
* added id field to Story and StoryGroup classes
* added iconImageUrl to StoryGroup class
* added openStory(storyGroupId: Int, storyId: Int?) method

### 1.6.0
* added quiz component for interactive stories

### 1.5.2
* added 'xlarge' story group size 
* added storyGroupIconForegroundColors method for 'xlarge' story groups gradient layer
* added storyGroupTextTypeface method
* added 'customParameter' parameter to StorylyInit to pass customized field for users

### 1.5.1
* fixed jagged edges in interactive poll component
* fixed a bug for rotated interactive action button
* increased padding size for rotated interactive action button

### 1.5.0
* added interactive stories support for poll
* updated placement of emoji reaction view

### 1.4.2
* fixed rare crash that occurs when story completes

### 1.4.1
* added 'Sponsored' indicator for ad story groups
* improved ad place calculation for better user experience
* fixed user experience for some native ad types

### 1.4.0
* added client side ad insertion flow
* fixed crash that occurs when deactivated story is opened with deeplink

### 1.3.1
* IMPORTANT! changed StorylyInit class definitions, please check README
* fixed a rare bug during transitions
* fixed crash during empty story group list scroll

### 1.3.0
* IMPORTANT! removed storylyId with storylyInit parameter, please check README
* IMPORTANT! changed openStory method signature, please check README
* added setExternalData api to extend personalized usage, please check Advanced Topics
* added segmentation of story groups
* added dynamic/runtime segmentation of story groups, please check Advanced Topics
* added 'large'(default one) and 'small' story group size 

### 1.2.1
* fix crash during deeplink openings

### 1.2.0
* Performance improvements on story transitions
* Added capability to open stories using deeplink generated from dashboard
* [Segmentify](https://www.segmentify.com/) integration to show personalized stories to users

### 1.1.0
* add interactive stories support for custom button action, text and emoji reaction

### 1.0.2
* improvements on placement for different device ratio including tablets

### 1.0.1
* improvements on placement for different device ratio
* fix orientation calculation issue

### 1.0.0
* IMPORTANT! change storylyLoad callback signature, please check README
* IMPORTANT! change storylyLoadFailed callback signature, please check README
* add storylyStoryShown and storylyStoryDismissed callbacks
* add show and dismis api
* rename StorylyData to StoryData
* improvements on cutout handling
* improvements on pull down and overscroll animations
* fix video black screen issue on some Samsung devices

### 0.0.22
* improvements on multiline textview

### 0.0.21
* improvements for phones with cutout display area(notch)
* add multiple instance support

### 0.0.20
* add animation for over scroll 
* improvements on video playback
* fix restoreInstance issue

### 0.0.19
* add pull down for close story
* add animation for transition between story groups
* fix android:nestedScrollingEnabled issue

### 0.0.18
* improvements on video story

### 0.0.15
* update icons for better UI
* fix action text case issue (uppercased by default)

### 0.0.14
* add UI customization APIs, please check README for details
* add pinned story flow
* improve story loading for better UX
* change action view icons
* fix progress bar style for older versions

### 0.0.13
* improvements on gestures

### 0.0.11
* add skeleton view for loading cases
* change storylyActionClicked delegate signature 
* ui changes
* fix video story playback
* add story title
* improvements on gestures

### 0.0.8
* add cubic animation to story transititon
* handle orientation changes

### 0.0.7
* add refresh API
* add story seen state handling
* add duration configuration from backend; current configuration is 7sec for image type stories, 15sec for video types

### 0.0.6
* add storylyActionClicked callback
