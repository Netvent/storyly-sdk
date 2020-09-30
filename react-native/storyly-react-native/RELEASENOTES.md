# Release Notes
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
