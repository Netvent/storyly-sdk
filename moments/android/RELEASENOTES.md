# Release Notes
### 1.0.0 (05.05.2023)
* improved moments configuration structure
* added custom font interface components
* added callbacks for like/view actions for analytics view customization
* added customization for link-cta interactive text color
* added customization for icons in moments interface
* added callback for link-cta url preview for webview customization
* added preview url to story media

### 0.6.0 (03.04.2023)
* added image and video components to pre-moderation
* added story snapshots to pre-moderation
* added async completion for pre-moderation

### 0.5.2 (28.03.2023)
* added dismiss method for user stories
* fixed text interactive character clipping

### 0.5.1 (11.03.2023)
* fixed a bug in search feature of in-app link cta

### 0.5.0 (22.02.2023)
* added like/view analytics buttons for User Stories screen
* added album options for gallery
* improved performance of gallery loading
* IMPORTANT! added Android 13 support by increasing compileSdk and targetSdk to 33

### 0.4.0 (23.01.2023)
* added move/rotation/scale support for media
* added gradient background for resized media
* added pre-moderation support before story upload
* fixed corrupted video issue during opening media gallery
* added storyHeaderClicked callback 

### 0.3.1 (14.12.2022)
* fixed a crash that forces usage of MaterialTheme

### 0.3.0 (13.12.2022)
* added past date information of story to header
* added mute option to video interactive component
* added localization(tr, pt, he) support

### 0.2.0 (23.11.2022)
* IMPORTANT! deprecated createStory and openMyStories methods
* IMPORTANT! added openStoryCreator and openUserStories methods
* IMPORTANT! deprecated onOpenCreateStory and onOpenMyStory callbacks
* IMPORTANT! added onStoryCreatorOpen/onStoryCreatorClose and onUserStoriesOpen/onUserStoriesClose callbacks
* fixed issue with resource conflicts for Storyly and Moments 
* added localization(en, es, de) support
* fixed drag gesture position issue for text interactive component
* fixed duplicate character issue on text interactive component
* fixed text cut issue on text interactive component
* improved span color selection of text interactive component
* improved keyboard open/close handling
* improved ui handling for Android API 24-

### 0.1.2 (14.11.2022)
* improved audio focus with video stories

### 0.1.1 (10.11.2022)
* removed ExoPlayer2 dependency
* added Storyly-ExoPlayer2 dependency, a custom fork of ExoPlayer2

### 0.1.0 (01.11.2022)
* added video media support for create story for both gallery and camera
* added text interactive component
* added link cta interactive component

### 0.0.7 (06.10.2022)
* improved story bar scrolling performance with pagination

### 0.0.6 (03.10.2022)
* fixed a crash on gallery page for prior to Android 19 devices

### 0.0.5 (12.09.2022)
* added MomentsUserPayload to handle encrytion of user payload in mobile side
* fixed a crash on MomentsListener callback due to ProGuard

### 0.0.3 (16.08.2022)
* fixed a camera not closing bug
* fixed onUserStoriesLoaded callback bug on first call

### 0.0.1 (01.07.2022)
* introduced Moments by Storyly, Please check [Moments by Storyly Android Documentation](https://integration.storyly.io/moments-android/quick-start.html)
