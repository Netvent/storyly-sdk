# Release Notes
### 2.6.0 (24.11.2023)
* added product feed feature for client side automated shoppable stories
  
### 2.5.1 (13.11.2023)
* improved story bar scrolling after data update
  
### 2.5.0 (06.11.2023)
* added improvements for text interactive components
* optimized story dismiss flow
* fixed a visual bug in countdown interactive component
  
### 2.4.0 (29.09.2023)
* added gif support for story group covers
* added multi region and language support for product feeds
  
### 2.3.1 (22.09.2023)
* optimized memory usage
* improved layout on orientation change, fixed [#291](https://github.com/Netvent/storyly-mobile/issues/291)
  
### 2.3.0 (09.09.2023)
* added support for google fonts from Storyly studio for text interactive component
* added support for instance theme settings from Storyly dashboard
* added Live story group type to support streaming urls
* converted emoji interactive component results from click counts to percentages
  
### 2.2.1 (25.08.2023)
* fixed a bug in story dismiss flow

### 2.2.0 (23.08.2023)
* IMPORTANT! increased minimum os version to 11; please refer to [Xcode 14 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes)
* IMPORTANT! removed armv7 and i386 arch support; please refer to [Xcode 14 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes)
* IMPORTANT! removed bitcode support; please refer to [Xcode 14 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes)
* IMPORTANT! deprecated dismiss, present, pause and resume methods
* IMPORTANT! added closeStory, pauseStory and resumeStory methods
* reduced framework size
* changed sound volume behavior for video stories
  
### 2.1.0 (17.08.2023)
* added result interactive components for poll, quiz, reaction, image quiz, rating, question
* added animation feature to interactive components entrance 
* added story group countdown badge
  
### 2.0.2 (28.07.2023)
* added facebook id configuration to enable instagram sharing to stories
  
### 2.0.1 (22.07.2023)
* improved re-initialization flow of StorylyInit
* improved data update flow of story screen, fixed [#287](https://github.com/Netvent/storyly-mobile/issues/287)
* improved seen state handling in story screen

### 2.0.0 (04.07.2023)
* added timed interactive feature for stories
* added conditional stories support
* added story group badge support
* IMPORTANT! added new config structure for storylyInit (Please refer to the [migration doc](https://docs.storyly.io/page/migrating-to-sdk-20))
* IMPORTANT! moved all ui and storyly customization fields into new config structure

### 1.33.1 (22.07.2023)
* improved data update flow of story screen, fixed [#287](https://github.com/Netvent/storyly-mobile/issues/287)
  
### 1.33.0 (03.07.2023)
* added cart synchronization for product catalog interactive component
* added product detail sheet support for cta interactive components

### 1.32.6 (05.06.2023)
* optimized memory usage
 
### 1.32.5 (18.05.2023)
* optimized memory usage, fixed [#278](https://github.com/Netvent/storyly-mobile/issues/278)
* fixed play mode handling of openStory method
* added specific callback for product add to cart
* added fail and success cases for add to cart action

### 1.32.4 (05.05.2023)
* improved appearance of button and swipe up interactives
* improved moments theme styling
* improved accessibility features
* improved product catalog interactive animation
* improved fallback mechanism of product retrieval
* fixed volume bar visibility issue

### 1.32.3 (14.04.2023)
* improved localizations for es

### 1.32.2 (10.04.2023)
* improved codebase to fix bugs from crash logs

### 1.32.1 (03.04.2023)
* fixed product and user data conflict

### 1.32.0 (28.03.2023)
* added product catalog interactive component
* added accessibilityIdentifier field for test setups

### 1.31.4 (13.03.2023)
* added events to support smart sorting in story list
* improved seen state for the story groups contains user property

### 1.31.3 (07.03.2023)
* IMPORTANT! fixed video playback issue introduced in 1.31.2

### 1.31.2 (06.03.2023)
* added local cache invalidation flow 
* added etag implementaion

### 1.31.1 (23.02.2023)
* improved data manager queue flow for skeleton view

### 1.31.0 (22.02.2023)
* added image quiz interactive component
* added color option to poll interactive component
* improved data manager queue flow
* added like/view analytics buttons for Moments story groups
* improved story area of Moments story groups
* fixed story group icon image's aspect 
* added story index to accessibilityLabel of story start

### 1.30.2 (10.02.2023)
* fixed [#263](https://github.com/Netvent/storyly-mobile/issues/263)

### 1.30.0 (23.01.2023)
* added product card interactive component
* added like/dislike feature for emoji interactive component
* changed design of the emoji interactive component
* added vertical/horizontal grid layout support
* IMPORTANT! added orientation, sections, horizontalEdgePadding, verticalEdgePadding, horizontalPaddingBetweenItems, verticalPaddingBetweenItems to StoryGroupListStyling
* IMPORTANT! removed edgePadding, paddingBetweenItems from StoryGroupListStyling
* added accessibility support for quiz and poll interactive components

### 1.29.0 (09.01.2023)
* IMPORTANT! changed design of swipe interactive component
* IMPORTANT! updated Xcode version to 13.2.1 for builds
* fixed storyGroup:iconUrl format for user generated content

### 1.28.2 (26.12.2022)
* improved progress timer deconstructor

### 1.28.1 (14.12.2022)
* updated seen state of story groups with User Property

### 1.28.0 (13.12.2022)
* IMPORTANT! added story group animation to borders, use storyGroupAnimation field to disable
* added past date information of story to header for moments story groups
* improved story bar scrolling performance with pagination
* added localization(pt) support
* improved crash report handling
* fixed visual bug on rotated interactive components

### 1.27.6 (14.11.2022)
* fix pin icon rendering issue for some devices
* fix story start issue for openStory methods
* fix story progress animation issue for some devices
* add localization support to share screen
* fix video playback issue for Moments stories

### 1.27.5 (14.11.2022)
* added share to Instagram Stories
* added storyly share sheet with story specific share features
* added accessibilityLabel to image cta interactive components

### 1.27.4 (08.11.2022)
* improved link cta interactive component

### 1.27.3 (21.10.2022)
* updated seen state of story groups with User Property when a new data set
* removed pin from personalized story groups

### 1.27.2 (06.10.2022)
* added story group id support to storylyShareUrl
* improved story bar scrolling performance with pagination

### 1.27.1 (04.10.2022)
* added MomentUser field to StoryGroup data

### 1.27.0 (19.09.2022)
* added link cta interactive component
* added share screenshot of personalized story groups

### 1.26.2 (12.09.2022)
* fixed iVOD story group not showing issue
* fixed crash on story opens in devices with iOS13-

### 1.26.0 (23.08.2022)
* added story bar animations with a/b test option
* improved story bar scrolling performance with pagination
* fixed story start bug for accessibility enabled cases
* fixed [#213](https://github.com/Netvent/storyly-mobile/issues/213)

### 1.25.0 (03.08.2022)
* IMPORTANT! changed StorylyInit constructors, check [StorylyInit API Reference](https://integration.storyly.io/api/ios/Classes/StorylyInit.html)

### 1.24.1 (29.07.2022)
* IMPORTANT! added colorSeen and colorNotSeen fields to StoryGroupTextStyling
* IMPORTANT! added storyGroupTextColorSeen and storyGroupTextColorNotSeen fields
* IMPORTANT! removed color field from StoryGroupTextStyling
* IMPORTANT! removed storyGroupTextColor field
* IMPORTANT! added storylyLayoutDirection field
* fixed text truncate issue for some devices for text interactive and promo code interative, [#192](https://github.com/Netvent/storyly-mobile/issues/192)

### 1.24.0 (01.07.2022)
* added swipe up designs with a/b test option
* added outlink parameter to countdown interactive component
* added accessibility features for navigation, story open/close, swipe/button/image cta interactive components

### 1.23.2 (02.06.2022)
* fixed story placement error on devices with notch for SwiftUI projects
* fixed promo code interactive component rendering for templates
* removed cdn fallback flow

### 1.23.1 (30.05.2022)
* added comment interactive component
* added StorylyMomentsDelegate for moments specific events
* fixed like/unlike click area
* added like/unlike haptic feedback 
* changed animation duration of bottom sheets

### 1.22.2 (23.4.2022)
* added currentTime field to Story object

### 1.22.1 (13.4.2022)
* added storylyShareUrl field for customized share urls 

### 1.22.0 (21.4.2022)
* introduced Moments by Storyly features, check for integration [Moment by Storyly iOS Integration Docs](https://integration.storyly.io/moments-ios/quick-start.html#installation) 
  * display user generated content in Storyly 
  * add customization to show Moments views
  * add like feature to user generated content
  * add reporting feature to user generated content

### 1.21.0 (14.4.2022)
* added support for 9:20 media assets
* increased swipe up interactive area
* added support for promo code interactive layer in external data
* fixed a wrong thread exception during ui customizations
* fixed SDWebImage conflicts, [#161](https://github.com/Netvent/storyly-mobile/issues/161)
* fixed SDWebImage related warnings, [#145](https://github.com/Netvent/storyly-mobile/issues/145)

### 1.20.2 (22.3.2022)
* fixed a possible crash on StoryComponent casting for storylyEvent

### 1.20.1 (15.3.2022)
* fixed a bug in setExternalData method
* fixed a crash in several opening of story group case

### 1.20.0 (14.3.2022)
* added StorylyInit.userData to support personalized story rendering
* added StoryComponent list to StoryMedia

### 1.19.4 (24.2.2022)
* fixed story group lis visual bug, flickering some cases
* fixed thematic icon management for story header view

### 1.19.3 (16.2.2022)
* fixed a crash during UI customization update from non main-thread
* improved text area usage of promo code interactive component
* fixed text alignment handling of text interacive component

### 1.19.2 (21.1.2022)
* fixed integration bug if [Add Storyly View Programmatically](https://integration.storyly.io/ios/initial-sdksetup.html#add-storyly-view-programmatically) is used

### 1.19.1 (18.1.2022)
* fixed visual bug related ui customization, story group icons rendered with wrong size during scroll

### 1.19.0 (18.1.2022)
* added theme options to product tag interactive component
* improved text interactive component rendering
* improved video loading performance

### 1.18.6 (3.1.2022)
* added lines field to [StoryGroupTextStyling](https://integration.storyly.io/api/ios/Classes/StoryGroupTextStyling.html), removed override flow of font size from textFont field. check [Story Group Text Styling Customization](https://integration.storyly.io/ios/ui-customizations.html#story-group-text-styling)

### 1.18.5 (24.12.2021)
* fixed play mode handling of openStory method

### 1.18.4 (17.12.2021)
* added name parameter to Story instance

### 1.18.3 (2.12.2021)
* added close and share button icon change api
* added StoryGroupUserOpened event for story open with user selection action
* fixed StoryShared event 
* released version with Xcode 12.5.1 for backward compatibility

### 1.18.2 (26.11.2021)
* fixed unexpeted story group transitions issue
* fixed [#144](https://github.com/Netvent/storyly-mobile/issues/144)

### 1.18.0 (18.11.2021)
* removed SDWebImage dependency
* added promo code interactive component
* fixed sdk version handling error due to Xcode 13
* added personalized story group name, story group icon and story title usage to setExternalData flow
* IMPORTANT! added dataSource field to storylyLoaded callback 

### 1.17.3 (05.11.2021)
* changed SDWebImage dependency as SDWebImage 5.10.x version to be minimum requirement

### 1.17.1 (03.11.2021)
* released version with Xcode 12.5.1 for backward compatibility

### 1.17.0 (21.10.2021)
* added image cta interactive component, a clickable image component

### 1.16.0 (15.10.2021)
* added customized story group style usage, check [Custom Story Group Styling](https://integration.storyly.io/ios/custom-story-group-styling.html)
* removed XLarge default style on story group size
* added previous story group automatic swipe when previous click on first story
* improved text size arrangements on text interactive components
* improved events to identify reach of story groups
* improved GIF rendering on image components

### 1.15.0 (10.09.2021)
* added RTL support
* added language support for Hebrew(HE-IW)

### 1.14.0 (27.08.2021)
* added play modes for programmatic story opens, check [Deep Linking and Programmatic Open](https://integration.storyly.io/ios/deep-linking.html)

### 1.13.3 (13.08.2021)
* improved video sound handling for silent/ringer modes

### 1.13.2 (02.08.2021)
* improved Split Mode handling on iPad devices, [#119](https://github.com/Netvent/storyly-mobile/issues/119)

### 1.13.0
* added multiple story group support for external data usage
* removed client side dynamic filtering feature 

### 1.12.0
* added storyInteractiveFont to support customizable fonts for interactive components
* added systemFont usage in interactive fonts

### 1.11.1
* added isTestMode field to StorylyInit to show test story groups, check [Test Mode](https://integration.storyly.io/ios/test-mode.html)
* improved status bar handling for specific devices, [#88](https://github.com/Netvent/storyly-mobile/issues/88)

### 1.11.0
* added image component for interactive stories
* added video component for interactive stories
* IMPORTANT! removed advertising id(idfa compatibility for iOS 14.5) usage
* IMPORTANT! removed url field from StoryMedia
* IMPORTANT! renamed rawValue of StorylyEvent to stringValue

### 1.10.1
* fixed a crash on fallback scenarios

### 1.10.0
* added product tag component for interactive stories
* improved story area usage 
* fixed pinned story groups ordering 
* fixed emoji rendering on text interactive components
* fixed font rendering on text interactive components

### 1.9.5
* fixed crash on iOS 12 devices, NSInternalInconsistencyException, [#72](https://github.com/Netvent/storyly-mobile/issues/72)

### 1.9.4
* fixed crash on iOS 12 devices, [#72](https://github.com/Netvent/storyly-mobile/issues/72)

### 1.9.3
* fixed crash runtime segmentation changes [#58](https://github.com/Netvent/storyly-mobile/issues/58)

### 1.9.2
* added actionUrlList to Story data
* fixed crash if storyHeaderIconIsVisible=false used [#52](https://github.com/Netvent/storyly-mobile/issues/52)

### 1.9.1
* added support for interactive components without titles
* added animation to swipe up icon and text
* added dynamic changes for storyly list updates
* added set language support for specific languages (TR, EN, RU, ES, DE, FR)
* added thematic icon support for story groups

### 1.9.0
* added Interactive VOD feature
* added vertical, horizontal and custom placement support for emoji component
* improved cube animation during transitions
* improved interactive layer rendering
* IMPORTANT! changed storylyActionClicked signature(removed return type)

### 1.8.9
* improved story header animation during long press
* improved cache flow

### 1.8.8
* added Story header animation during long press
* improved Xcode12.2 support(Swift 5.3.1 support)

### 1.8.7
* added storylyEvents method to StorylyListener
* added 'seen' field to StoryGroup and Story
* improved Xcode12 support(Swift 5.3 support)

### 1.8.5
* improved initialization handling

### 1.8.4
* added StoryGroupListStyling to support customization of story group list view, added 'storyGroupListEdgePadding' as storyboard and programmatic attributes
* moved 'storyGroupListPaddingBetweenItems' to StoryGroupListStyling
* improved share link generation
* fixed story header font update bug
* improved swipe down close animation for newer iPhone devices

### 1.8.3
* improved UI components for better iOS14 support
* improved status bar management

### 1.8.2
* added 'storyItemTextFont' as storyboard and programmatic attribute to support custom font for story title
* added 'isCloseButtonVisible' attribute to StoryHeaderStyling and 'storyHeaderCloseButtonIsVisible' as storyboard and programmatic attribute for visibility option of close button
* added 'showExternalActionView' and 'dismissExternalActionView' methods to support external custom view to show and dismiss while stories are being shown
* added 'storylyLoadingView' attribute to support external custom loading view instead of using default loading view

### 1.8.0
* added rating component for interactive stories
* added language support for en, tr, de, fr, ru, es locales
* added StoryGroupIconStyling to support custom size story groups, added 'storyGroupIconWidth', 'storyGroupIconHeight', 'storyGroupIconCornerRadius' and 'storyGroupPaddingBetweenItems' as storyboard and programmatic attributes
* added StoryGroupTextStyling for visibility handling of elements, added 'storyGroupTextIsVisible' as storyboard and programmatic attribute
* added StoryHeaderStyling for visibility handling of elements, added 'storyHeaderIconIsVisible', 'storyHeaderTextIsVisible' as storyboard and programmatic attributes
* added runtime update feature for StorylyInit's segmentation parameters

### 1.7.3
* fixed compile issue due to swift backward compatibility

### 1.7.2
* added storylyUserInteracted(storylyView: StorylyView, storyGroup: StoryGroup, story: Story, storyComponent: StoryComponent) callback
* improved events for better analysis

### 1.7.0
* added countdown component for interactive stories
* added share feature to stories
* removed close button from stories

### 1.6.2
* improved event payload for better analysis

### 1.6.1
* added id field to Story and StoryGroup classes
* added iconImageUrl to StoryGroup class
* added openStory(storyGroupId: Int, storyId: Int?) method
* added thumbnail image to video stories
* improved event payload for better analysis

### 1.6.0
* added quiz component for interactive stories
* removed use_frameworks! constraint for CocoaPods integrations

### 1.5.5
* fixed compile issue due to swift backward compatibility (issue: inheritance from non-protocol type 'UIView')

### 1.5.4
* added 'xlarge' story group size 
* added storyGroupIconForegroundColors method for 'xlarge' story groups gradient layer
* added storyGroupTextTypeface method
* added 'customParameter' parameter to StorylyInit to pass customized field for users

### 1.5.3
* fixed a bug in external data

### 1.5.1
* added frame parameter to StorylyExternalViewProvider callback to support better sizing

### 1.5.0
* added interactive stories support for poll
* updated placement of emoji reaction view

### 1.4.0
* added client side ad insertion flow
* improved StorylyInit and StorylySegmentation class initializers for ObjC
* added BUILD_LIBRARY_FOR_DISTRIBUTION as compile option to support backward Swift compatibility

### 1.3.2
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

### 1.2.2
* add dependency to podspec

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
* improvement on orientation change handling for iPads

### 1.0.1
* improvements on placement for different device ratios
* fix pin icon bug

### 1.0.0
* IMPORTANT! change storylyLoad callback signature, please check README
* IMPORTANT! change storylyLoadFailed callback signature, please check README
* add storylyStoryPresented and storylyStoryDismissed callbacks
* rename StorylyData to StoryData
* improvements on pull down and overscroll animations

### 0.0.22
* improvements on notch handling
* improvements on dismiss animation for iPhoneX
* fix StorylyView constructors' visibility modifier issue

### 0.0.21
* fix gesture handling for overscroll dismiss

### 0.0.20
* add pull down for close story
* add animation to dismiss action
* add multiple instance support
* fix video buffer issue
* significant improvements on performance

### 0.0.19
* improvements and modications

### 0.0.18
* rename appId to storylyId
* improvements on video story

### 0.0.15
* improvements for iPhoneX

### 0.0.14
* add UI customization APIs, please check README for details
* add pinned story flow
* improve story loading for better UX
* change action view icons

### 0.0.13
* add BUILD_LIBRARY_FOR_DISTRIBUTION setting
* improvements on gestures

### 0.0.11
* add skeleton view for loading cases
* improvements on gestures
* enable bitcode generation

### 0.0.10
* change storylyActionClicked delegate signature 
* ui changes
* fix video story playback

### 0.0.9
* add pause/resume API
* add story title

### 0.0.8
* add cubic animation to story transititon
* handle orientation changes

### 0.0.7
* add refresh API
* add story seen state handling
* add duration configuration from backend; current configuration is 7sec for image type stories, 15sec for video types

### 0.0.6
* add storylyActionClicked deleagate
* Swift 5.1 compatibility
