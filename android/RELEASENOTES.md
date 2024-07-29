# Release Notes
### 3.4.0 (29.07.2024)
* added out of stock handling for product related interactive components

### 3.3.0 (29.07.2024)
* added video covers for story groups
* fixed a bug related to device orientation for tablets
  
### 3.2.1 (22.07.2024)
* improved storyly widget related analytic events
* improved story group visibility related analytic events
* improved handling of missing monetization fields
* changed logo and text of Twitter to X on share sheet

### 3.2.0 (28.06.2024)
* added sponsored story group feature
  
### 3.1.0 (12.06.2024)
* improved story group cover selection flow with focal points
* improved missing product handling by filtering stories
* fixed a typo in portuguese translation
  
### 3.0.1 (27.05.2024)
* added sdk play console verification

### 3.0.0 (21.05.2024)
* improved load time of the Storyly Widget
* removed Storyly Moments
* IMPORTANT! removed StoryMedia class and media field from public Story class
* IMPORTANT! added previewUrl, actionUrl and storyComponentList to the public Story class

### 2.19.0 (12.06.2024)
* improved story group cover selection flow with focal points
* improved missing product handling by filtering stories
* fixed a typo in portuguese translation

### 2.18.3 (27.05.2024)
* added sdk play console verification
  
### 2.18.2 (20.05.2024)
* added key field for product variants to indicate variant type
* fixed a visual bug for poll and quiz interactive components
  
### 2.18.1 (13.05.2024)
* fixed an issue related to product payload of story impression events 

### 2.18.0 (10.05.2024)
* improved placement of product tag interactive component based on content
* improved payload of product events
* improved monetization templates
  
### 2.17.3 (06.05.2024)
* improved usage of actionUrl and products in storylyActionClicked callback
* fixed an issue related to visibility of the product catalog interactive component

### 2.17.2 (24.04.2024)
* fixed thumbnail image load issue of video stories
* fixed a bug related to cta behavior of product related interactive components
* fixed icon corner radius flick on fragment transitions
* fixed a bug related to icon corner radius on android 8 and below devices
  
### 2.17.1 (06.04.2024)
* fixed a bug related to product sheet colors

### (DEPRECATED) 2.17.0 (05.04.2024)
* fixed RTL support issues for product related interactive components
* fixed bugs related to conditional stories
* added additional bottom sheet customizations for product related interactive components
* improved bottom sheet functionality for product related interactive components
* improved network requests
* improved StorylyDataSource by simplifying the sources for storylyLoaded callback
  
### 2.16.1 (19.03.2024)
* improved analytic events
* fixed a bug related to z-index of interactive components
  
### 2.16.0 (11.03.2024)
* improved price formatting for product related interactive components
* fixed a bug related to interactive component representation
* improved action flow for product related interactive components

### 2.15.0 (27.02.2024)
* improved media url handling
* improved functionality of product catalog interactive component
* fixed a bug related to product cart state
  
### 2.14.0 (19.02.2024)
* added animations for text interactive component
  
### 2.13.1 (26.01.2024)
* fixed a bug related to scroll position in storyly bar
  
### 2.13.0 (24.01.2024)
* improved functionality and design of story group countdown badge
  
### 2.12.0 (10.01.2024)
* added video position/resize handling
* added static inputs for product catalog interactive component
* improved data processing flow
  
### 2.10.1 (27.12.2023)
* fixed a bug related to conditional stories flow
* fixed IllegalStateException during activity recreation
  
### 2.10.0 (25.12.2023)
* added background image position/resize handling
* fixed a ui bug related to outlineProvider
  
### 2.9.0 (22.12.2023)
* improved data cache flow
* changed storyly-exoplayer2 dependency to 2.18.1-1
* fixed a bug related to story group size
  
### 2.8.0 (15.12.2023)
* IMPORTANT! changed type of products parameter in StorylyProductListener storylyHydration callback
* added nudge stories
* improved data update flow of story bar
* fixed a bug related to conditional stories flow
  
### 2.7.0 (05.12.2023)
* IMPORTANT! added setLocale function to StorylyConfig; please refer to [Localization documentation](https://docs.storyly.io/docs/android-initial-sdk-setup#localization)
* IMPORTANT! removed languageCode; please use setLocale function
* IMPORTANT! removed product country and language from StorylyProductConfig; please use setLocale function
* added animation for not-fitting images in automated shoppable image layers
* improved story screen reset flow

### 2.6.0 (24.11.2023)
* added product feed feature for client side automated shoppable stories
  
### 2.5.2 (16.11.2023)
* fixed a bug related to group select, fixed [#321](https://github.com/Netvent/storyly-mobile/issues/321)
  
### 2.5.1 (13.11.2023)
* improved story bar scrolling after data update, fixed [#320](https://github.com/Netvent/storyly-mobile/issues/320)
  
### 2.5.0 (06.11.2023)
* added improvements for text interactive components
* optimized story dismiss flow
* optimized memory usage
* fixed a visual bug in quiz interactive component
  
### 2.4.0 (29.09.2023)
* added gif support for story group covers
* added multi region and language support for product feeds
  
### 2.3.2 (22.09.2023)
* optimized memory usage
  
### 2.3.1 (12.09.2023)
* improved code obfuscation for dexguard
  
### 2.3.0 (09.09.2023)
* added support for google fonts from Storyly studio for text interactive component
* added support for instance theme settings from Storyly dashboard
* added Live story group type to support streaming urls
* converted emoji interactive component results from click counts to percentages

### 2.2.0 (23.08.2023)
* IMPORTANT! deprecated dismiss and show methods
* IMPORTANT! added closeStory, pauseStory and resumeStory methods
* fixed a bug related to group select
  
### 2.1.0 (17.08.2023)
* added result interactive components for poll, quiz, reaction, image quiz, rating, question
* added animation feature to interactive components entrance 
* added story group countdown badge

### 2.0.3 (28.07.2023)
* added facebook id configuration to enable instagram sharing to stories
* improved thread management for disk operations 
  
### 2.0.2 (22.07.2023)
* improved re-initialization flow of StorylyInit
* fixed edge paddings of storyly bar
* improved save/restore instance flow 
* fixed a crash related to AttributeSet interface

### 2.0.0 (04.07.2023)
* added timed interactive feature for stories
* added conditional stories support
* added story group badge support
* IMPORTANT! added new config structure for storylyInit (Please refer to the [migration doc](https://docs.storyly.io/page/migrating-to-sdk-20))
* IMPORTANT! moved all ui and storyly customization fields into new config structure

### 1.34.0 (12.09.2023)
* improved code obfuscation for dexguard
  
### 1.33.2 (22.07.2023)
* fixed edge paddings of storyly bar

### 1.33.1 (03.07.2023)
* fixed black screen issue related to storyly view dismiss

### 1.33.0 (03.07.2023)
* added cart synchronization for product catalog interactive component
* added product detail sheet support for cta interactive components
* optimized memory usage, fixed [#289](https://github.com/Netvent/storyly-mobile/issues/289)

### 1.32.6 (05.06.2023)
* improved codebase to prevent ArrayIndexOutOfBoundsException [#183](https://github.com/Netvent/storyly-mobile/issues/183)
* improved story pause/resume state for product catalog flow

### 1.32.5 (25.05.2023)
* improved pagination of story groups

### 1.32.4 (18.05.2023)
* optimized memory usage, fixed [#251](https://github.com/Netvent/storyly-mobile/issues/251), [#164](https://github.com/Netvent/storyly-mobile/issues/164)
* added specific callback for product add to cart
* added fail and success cases for add to cart action

### 1.32.3 (05.05.2023)
* improved appearance of button and swipe up interactives
* improved corner radius of images
* improved moments theme styling
* improved accessibility features
* improved product catalog interactive animation
* improved fallback mechanism of product retrieval
* improved storyly bar loading flow

### 1.32.2 (14.04.2023)
* fixed crash during share
* fixed wrong edge padding issue in grid layout

### 1.32.1 (03.04.2023)
* improved codebase to prevent ConcurrentModificationException [#204](https://github.com/Netvent/storyly-mobile/issues/204)
* fixed product and user data conflict

### 1.32.0 (28.03.2023)
* added product catalog interactive component
* fixed crash during share
* added activity field

### 1.31.3 (11.03.2023)
* added events to support smart sorting in story list
* improved seen state for the story groups contains user property

### 1.31.2 (07.03.2023)
* added local cache invalidation flow 
* added etag implementaion
* fixed padding issue for rtl devices

### 1.31.1 (23.02.2023)
* improved data manager queue flow for skeleton view

### 1.31.0 (22.02.2023)
* added image quiz interactive component
* added color option to poll interactive component 
* improved data manager queue flow
* added like/view analytics buttons for Moments story groups
* improved story area of Moments story groups
* added story index to contentDescription of story start
* IMPORTANT! added Android 13 support by increasing compileSdk and targetSdk to 33

### 1.30.0 (23.01.2023)
* added product card interactive component
* added like/dislike feature for emoji interactive component
* changed design of the emoji interactive component
* added vertical/horizontal grid layout support
* IMPORTANT! added orientation, sections, horizontalEdgePadding, verticalEdgePadding, horizontalPaddingBetweenItems, verticalPaddingBetweenItems to StoryGroupListStyling
* IMPORTANT! removed edgePadding, paddingBetweenItems from StoryGroupListStyling
* added accessibility support for quiz and poll interactive components
* reduced the sdk size by optimizing the asset usage

### 1.29.0 (09.01.2023)
* IMPORTANT! changed design of swipe interactive component
* fixed storyGroup:iconUrl format for user generated content

### 1.28.4 (05.01.2023)
* fix ClassCastException when share button clicked

### 1.28.2 (18.12.2022)
* improved codebase to prevent ConcurrentModificationException [#204](https://github.com/Netvent/storyly-mobile/issues/204)

### 1.28.1 (14.12.2022)
* updated seen state of story groups with User Property

### 1.28.0 (13.12.2022)
* IMPORTANT! added story group animation to borders, use storyGroupAnimation field to disable
* added past date information of story to header for moments story groups
* improved story bar scrolling performance with pagination
* added localization(pt) support

### 1.27.3 (23.11.2022)
* fixed issue with resource conflicts for Storyly and Moments
* added localization support to share screen
* fixed video playback issue for Moments stories

### 1.27.2 (14.11.2022)
* added share to Instagram Stories
* added storyly share sheet with story specific share features
* improved audio focus with video stories
* added contentDescription to image cta interactive components

### 1.27.0 (01.11.2022)
* added link cta interactive component

### 1.26.8 (21.10.2022)
* updated seen state of story groups with User Property when a new data set
* removed pin from personalized story groups
* fixed tracking event payload issue related to Reach

### 1.26.7 (20.10.2022)
* fixed story group disappear issue for several initialization case

### 1.26.6 (06.10.2022)
* added story group id support to storylyShareUrl
* fixed cast exception on StoryCommentComponent
* fixed MomentUser field visibility modifiers

### 1.26.4 (03.10.2022)
* added MomentUser field to StoryGroup data
* fixed duplicate moments story group issue
* fixed a bug on report story feature 

### 1.26.3 (19.09.2022)
* fixed duplicate moment view issue
* fixed swipe up size calculation for some devices
* fixed comment interactive layer rendering

### 1.26.2 (12.09.2022)
* fixed iVOD story group not showing issue
* fixed duplicate moments story group issue

### 1.26.1 (06.09.2022)
* fixed a crash during initialization with userPayload
* improved accessibility features with talkback feature

### 1.26.0 (23.08.2022)
* added story bar animations with a/b test option
* improved story bar scrolling performance with pagination
* fixed text alignment issue in interactive components if style is given

### 1.25.1 (04.08.2022)
* changed Storyly-ExoPlayer2 dependency to 1.28.0-1

### 1.25.0 (03.08.2022)
* IMPORTANT! changed StorylyInit constructors, check [StorylyInit API Reference](https://integration.storyly.io/api/android/storyly/com.appsamurai.storyly/-storyly-init/index.html)

### 1.24.2 (29.07.2022)
* IMPORTANT! added colorSeen and colorNotSeen fields to StoryGroupTextStyling
* IMPORTANT! added storyGroupTextColorSeen and storyGroupTextColorNotSeen fields
* IMPORTANT! removed color field from StoryGroupTextStyling
* IMPORTANT! removed storyGroupTextColor field
* IMPORTANT! added storylyLayoutDirection field
* fixed a crash during reinitialization of StorylyView with MomentsItems
* fixed [#202](https://github.com/Netvent/storyly-mobile/issues/202)

### 1.24.1 (23.07.2022)
* removed ExoPlayer2 dependency
* added Storyly-ExoPlayer2 dependency, a custom fork of ExoPkayer2

### 1.24.0 (01.07.2022)
* added swipe up designs with a/b test option
* added outlink parameter to countdown interactive component
* added application icon to countdown notification
* IMPORTANT! removed NOTIFICATION_GROUP_ID, added NOTIFICATION_LINK in StorylyNotificationReceiver
* added accessibility features for navigation, story open/close, swipe/button/image cta interactive components

### 1.23.3 (27.06.2022)
* added exported=false decleration to StorylyNotificationReceiver for countdown reminder for Android 31 support
* IMPORTANT! renamed storyGroup:uniqueId and story:uniqueId fields and change types to string

### 1.23.2 (17.06.2022)
* introduced Moments by Storyly features
  * display user generated content in Storyly 
  * add customization to show Moments views
  * add like feature to user generated content
  * add reporting feature to user generated content

### 1.23.1 (02.06.2022)
* fixed resuming story on wrong index for show/dismiss methods
* fixed promo code interactive component rendering for templates
* removed cdn fallback flow

### 1.23.0 (29.5.2022)
* added comment interactive component

### 1.21.4 (23.5.2022)
* added currentTime field to Story object

### 1.21.3 (13.5.2022)
* added storylyShareUrl field for customized share urls 

### 1.21.2 (22.4.2022)
* fixed ContextWrapper(nested wrappers) handling for not opening story bug

### 1.21.1 (16.4.2022)
* fixed crash on save/restore instance flow
* reduced compileSdk and targetSdk to 30

### 1.21.0 (14.4.2022)
* added support for 9:20 media assets
* increased swipe up interactive area
* added support for promo code interactive layer in external data
* updated RecyclerView dependency to 1.2.1
* fixed ContextThemeWrapper handling for not opening story bug
* fixed ConcurrentModificationException

### 1.20.5 (1.4.2022)
* fixed a PendingIntent crash on story share for Android S+ devices

### 1.20.4 (31.3.2022)
* fixed a possible crash on StoryComponent casting for storylyEvent

### 1.20.3 (22.3.2022)
* fixed a possible crash on StoryComponent casting for storylyEvent

### 1.20.2 (17.3.2022)
* removed kotlin-parcelize dependency requirement

### 1.20.1 (15.3.2022)
* fixed a bug in setExternalData method

### 1.20.0 (14.3.2022)
* added StorylyInit.userData to support personalized story rendering
* added StoryComponent list to StoryMedia
* updated ExoPlayer to 2.17.1; compileSdkVersion and targetSdk to 31
* fixed crash during restore instace handling

### 1.19.3 (24.2.2022)
* fixed story group lis visual bug, flickering some cases
* fixed thematic icon management for story header view

### 1.19.2 (16.2.2022)
* fixed [#148](https://github.com/Netvent/storyly-mobile/issues/148)
* fixed IllegalStateException with openStory method usage
* fixed 'storyGroupTextIsVisible' not affecting UI bug for first open of StorylyView

### 1.19.1 (18.1.2022)
* fixed visual bug related ui customization, story group icons rendered with wrong size during scroll

### 1.19.0 (18.1.2022)
* added theme options to product tag interactive component
* improved text interactive component rendering

### 1.18.6 (3.1.2022)
* added textSize, minLines, maxLines and lines fields to [StoryGroupTextStyling](https://integration.storyly.io/api/android/storyly/com.appsamurai.storyly.styling/-story-group-text-styling/index.html), check [Story Group Text Styling Customization](https://integration.storyly.io/android/ui-customizations.html#story-group-text-styling)

### 1.18.5 (24.12.2021)
* fixed border color visual bug for seen state changes

### 1.18.4 (17.12.2021)
* added name parameter to Story instance

### 1.18.3 (2.12.2021)
* added close and share button icon change api
* added StoryGroupUserOpened event for story open with user selection action
* fixed StoryShared event 

### 1.18.2 (26.11.2021)
* fixed [#142](https://github.com/Netvent/storyly-mobile/issues/142)
* fixed [#144](https://github.com/Netvent/storyly-mobile/issues/144)
* fixed crash for multiple story group clicks, [#134](https://github.com/Netvent/storyly-mobile/issues/134)

### 1.18.0 (18.11.2021)
* added promo code interactive component
* improved video playback, please check java 1.8 compatibility during integration
* added personalized story group name, story group icon and story title usage to setExternalData flow
* IMPORTANT! added dataSource field to storylyLoaded callback 

### 1.17.0 (21.10.2021)
* added image cta interactive component, a clickable image component
* fixed crash for multiple story group clicks, [#134](https://github.com/Netvent/storyly-mobile/issues/134)

### 1.16.0 (15.10.2021)
* added customized story group style usage, check [Custom Story Group Styling](https://integration.storyly.io/android/custom-story-group-styling.html)
* removed XLarge default style on story group size
* added previous story group automatic swipe when previous click on first story
* improved text size arrangements on text interactive components
* improved events to identify reach of story groups

### 1.15.2 (24.09.2021)
* improved poll animation and result text alignment 
* fixed [#127](https://github.com/Netvent/storyly-mobile/issues/127)

### 1.15.1 (23.09.2021)
* fixed a crash on interactive vod stories
* fixed [#131](https://github.com/Netvent/storyly-mobile/issues/131)
* improved handling for a crash, [#132](https://github.com/Netvent/storyly-mobile/issues/132)

### 1.15.0 (10.09.2021)
* added RTL support
* added language support for Hebrew(HE-IW)

### 1.14.0 (27.08.2021)
* added play modes for programmatic story opens, check [Deep Linking and Programmatic Open](https://integration.storyly.io/android/deep-linking.html)

### 1.13.5 (13.08.2021)
* improved image component for interactive stories

### 1.13.4 (06.08.2021)
* updated project dependencies, reverted kotlin version to 1.4.32

### 1.13.3 (04.08.2021)
* improved Fragment usage related crashes
* removed obsolete dependency, 'androidx.lifecycle:lifecycle-extensions:2.2.0'

### 1.13.2 (02.08.2021)
* fixed Fragment$InstantiationException [#123](https://github.com/Netvent/storyly-mobile/issues/123)
* fixed rtl enabled/disabled handling on interactive components [#124](https://github.com/Netvent/storyly-mobile/issues/124)

### 1.13.0
* added multiple story group support for external data usage
* fixed [#114](https://github.com/Netvent/storyly-mobile/issues/114)
* fixed [#111](https://github.com/Netvent/storyly-mobile/issues/111)
* fixed [#107](https://github.com/Netvent/storyly-mobile/issues/107)
* removed client side dynamic filtering feature

### 1.12.0
* added setStoryInteractiveTextTypeface to support customizable fonts for interactive components
* added systemFont usage in interactive fonts

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
