# Release Notes
* These are Fabric supported package of storyly-react-native, for the older architecture please use [storyly-react-native](https://github.com/Netvent/storyly-mobile/blob/master/react-native/storyly-react-native/RELEASENOTES.md) package.
### 4.17.1 (24.10.2025)
* added video cover support for vertical feed view
* fixed an interaction bug related to comment interactive component on ios platform

### 4.17.0 (02.09.2025)
* updated dependencies for React 19
* improved view hierarchy of the story screen on ios platform

### 4.16.3 (14.08.2025)
* fixed a bug related to visible story group tracking on android platform
* fixed a bug related to image group cover reset on android platform
* improved memory management for widget gallery on android platform
* improved interactive component add/remove flow on android platform
* fixed a bug related to scrolling in product detail sheet for vertical feed on android platform
* fixed audio session handling for storyly on ios platform
* fixed pause/resume flow after closing bottom sheet for vertical feed on ios platform

### 4.16.1 (27.06.2025)
* fixed a bug related to vertical bar orientation of storyly view on ios platform
* fixed a bug related to scrolling in product detail sheet for vertical feed on android platform

### 4.16.0 (23.06.2025)
* improved orientation changes for large screens by covering Android 16 changes on android platform
* improved countdown interactive component alarm schedule as exact on android platform
* fixed audio session handling for video covers on ios platform
* improved audio session handling for video stories on ios platform
* fixed a bug related to bar styling changes on initialization on ios platform

### 4.15.2 (12.06.2025)
* fixed a bug related to custom styling group unmount

### 4.15.1 (29.05.2025)
* fixed a bug related to hot reload for custom styling on ios platform
* fixed a bug related to Storyly views when a Picture-in-Picture activity is active on android platform
* improved countdown interactive component alarm schedule as exact on android platform

### 4.15.0 (16.05.2025)
* fixed a bug related to story group title custom font size
* fixed a bug related to dark cover update for custom styling
* fixed a bug related to scrapped and detached views in StorylyBar on android platform
* fixed a bug related to story header icon visibility on android platform
* fixed a bug related to swipe interactive component animation on android platform
* changed emoji library to emoji2 on android platform
* fixed a bug related to energized group badges on ios platform

### 4.13.2 (02.05.2025)
* fixed RTL assignment in StorylyConfig
* fixed size conversion of custom styling on android platform

### 4.13.1 (25.04.2025)
* improved layout of custom styling on android platform

### 4.13.0 (16.04.2025)
* fixed a bug related to timed interactive animations on android platform
* added data cache invalidation for customParameter changes
* improved asset load mechanism by prioritizing app bundle on ios platform
* improved interactive component initial animations for prefetched stories on ios platform
* fixed a memory leak related to video covers on ios platform
* fixed a bug related to custom group styling events on ios platform
* added StorylyBarImpression as a public Storyly event
* improved iconUrl of StoryGroup by providing dark theme url
* fixed a bug related to re-addition of product card interactive component on android platform
* fixed a bug related to border color of rating interactive component on ios platform
* fixed a bug related to keyboard focus of comment interactive component on ios platform
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
* fixed a bug related opacity of image quiz interactive component on android platform
* fixed a crash related to countdown interactive component on android platform
* fixed a crash related to video cache on ios platform
* fixed layout issues on iPad devices for Storyly  on ios platform
* added missing localization fields for Hebrew
* added framework information for analytical purposes
* added support for tap and go groups
* fixed a bug related to StorylyView edge padding on android platform
* fixed resizing of CTA button of product bottom sheet on android platform
* improved failure recovery for analytic requests on android platform
* improved interactive component initial animations for prefetched stories on android platform  
* fixed a bug related to story group/story transitions when voiceover is enabled on ios platform
* fixed a bug related to RTL layouts for storyly on ios platform
* IMPORTANT! fixed crash related to widget style on android platform
* improved story rendering while transitioning between stories
* improved skeleton view rendering flow
* fixed areas for next/previous clicks for RTL layouts
* fixed a bug related to openStory for sg play mode
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
* IMPORTANT! renamed products field to actionProducts in Story class
* added new public interactive component types
* improved StorylyView initialization flow
* fixed a bug related to style changes
* added video cache for video stories
* improved interactive component add/remove flow on android platform
* improved activity assignment flow in StorylyView on android platform
* improved data processing flow on android platform
* improved memory usage of gif media on ios platform
* improved synchronization between video story media and header on ios platform
* improved AVAudioSession category changes on ios platform
* fixed missing product url on android platform
* fixed a nullability issue
* added story bar instance settings
* fixed a bug related to IllegalStateException on android platform
* fixed a bug related to Storyly load on android platform
* fixed a bug related to click action analytics on android platform
* improved story header icon background on android platform
* improved layout of story group and header icon on android platform
* fixed bug related to interactive component interaction on ios platform
* fixed a positioning bug related to custom styling
* added out of stock handling for product related interactive components
* added video covers for story groups
* fixed a bug related to device orientation for tablets on android platform
* fixed instagram store id for share sheet on ios platform
* improved storyly widget related analytic events
* improved story group visibility related analytic events
* improved missing monetization fields handling
* changed logo and text of Twitter to X on share sheet
* improved story share handling for missing social apps on ios platform
* added sponsored story group feature
* added style field to StoryGroup interface
* fixed a bug related to custom styling
* improved story group cover selection flow with focal points
* improved missing product handling by filtering stories
* fixed a typo in portuguese translation on android platform
* improved monetization templates on ios platform
* improved load time of the Storyly Widget
* removed Storyly Moments
* IMPORTANT! removed StoryMedia class and media field from public Story class
* IMPORTANT! added previewUrl, actionUrl and storyComponentList to the public Story class
* added key field for product variants to indicate variant type
* fixed a visual bug for poll and quiz interactive components on android platform
* improved placement of product tag interactive component based on content
* improved payload of product events
* fixed storylyStoryDismissed delegate trigger time on ios platform
* fixed an issue related to product payload of story impression events on android platform
* improved monetization templates on android platform
* improved usage of actionUrl and products in storylyActionClicked callback
* fixed an issue related to visibility of the product catalog interactive component on android platform
* fixed a bug related to analytics requests on ios platform
* fixed thumbnail image load issue of video stories
* fixed story dismiss issue after a non-modal view controller presented over stories on ios platform
* fixed a bug related to cta behavior of product related interactive components on android platform
* fixed icon corner radius flick on fragment transitions on android platform
* fixed a bug related to icon corner radius on android 8 and below devices on android platform
* fixed RTL support issues for product related interactive components
* fixed bugs related to conditional stories
* added additional bottom sheet customizations for product related interactive components
* improved bottom sheet functionality for product related interactive components
* improved StorylyDataSource by simplifying the sources for storylyLoaded callback
* improved network requests on android platform
* fixed a bug related to product sheet colors on android platform
* added privacy manifest files for the upcoming SDK requirements on ios platform
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
* fixed a bug related to scroll position in storyly bar on android platform
* fixed an orientation bug for devices having iOS version <16 on ios platform

### 2.12.0 (12.01.2024)
* added video position/resize handling
* added static inputs for product catalog interactive component
* improved data processing flow
* fixed a simulator architecture bug for cocoapods on ios platform

### 2.11.0 (09.01.2024)
* IMPORTANT! increased minimum os version to 12 on ios platform; please refer to [Xcode 15 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes)

### 2.10.0 (27.12.2023)
* improved data cache flow
* fixed a bug related to conditional stories flow
* added background image position/resize handling
* fixed IllegalStateException during activity recreation on android platform
* fixed a ui bug related to outlineProvider on android platform
* changed storyly-exoplayer2 dependency to 2.18.1-1 on android platform
* fixed a bug related to story group size on android platform

### 2.8.0 (18.12.2023)
* IMPORTANT! changed type of products parameter onProductHydration callback
* added nudge stories
* improved data update flow of story bar 
* fixed a bug related to conditional stories flow
* optimized memory management of SDWebImage on ios platform

### 2.7.0 (06.12.2023)
* improved codebase

### 2.6.0 (06.12.2023)
* IMPORTANT! added storylyLocale property for localization; please refer to [Localization documentation](https://docs.storyly.io/docs/ios-initial-sdk-setup#localization)
* IMPORTANT! removed storyProductCountry and storyProductLanguage properties; please use storylyLocale property
* added animation for not-fitting images in automated shoppable image layers
* added storyProductFeed property for client side automated shoppable stories
* improved story screen reset flow on android platform

### 2.5.2 (16.11.2023)
* improved story bar scrolling after data update
* changed storyId parameter to nullable for openStoryWithId function 
* fixed a bug related to group select on android platform

### 2.5.1 (09.11.2023)
* added improvements for text interactive components
* optimized story dismiss flow
* optimized memory usage on android platform
* fixed a visual bug in quiz interactive component on android platform
* fixed a visual bug in countdown interactive component on ios platform

### 2.5.0 (10.10.2023)
* IMPORTANT! migrated to [Fabric](https://reactnative.dev/architecture/fabric-renderer)