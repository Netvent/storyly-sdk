# Release Notes
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
