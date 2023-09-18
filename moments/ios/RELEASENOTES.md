# Release Notes
### 1.0.1 (18.09.2023)
* fixed media import 
  
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

### 0.5.1 (28.03.2023)
* added dismiss method for user stories

### 0.5.0 (22.02.2023)
* added like/view analytics buttons for User Stories screen
* fixed accessing albums from iCloud 

### 0.4.0 (23.01.2023)
* added move/rotation/scale support for media
* added gradient background for resized media
* added pre-moderation support before story upload
* fixed mute state of video in preview screen
* added storyHeaderClicked callback 

### 0.3.1 (26.12.2022)
* fixed a crash during story delete

### 0.3.0 (13.12.2022)
* added past date information of story to header
* added mute option to video interactive component
* added localization(tr, pt, he) support

### 0.2.0 (24.11.2022)
* IMPORTANT! deprecate createStory and openMyStories methods
* IMPORTANT! add openStoryCreator and openUserStories methods
* IMPORTANT! deprecate onOpenCreateStory and onOpenMyStory callbacks
* IMPORTANT! add onStoryCreatorOpen/onStoryCreatorClose and onUserStoriesOpen/onUserStoriesClose callbacks
* add localization(en, es, de) support
* improve position, cursor indicator handling on text interactive components

### 0.1.6 (14.11.2022)
* fixed keyboard opening issue on some devices 

### 0.1.5 (08.11.2022)
* improved link cta interactive component

### 0.1.3 (10.10.2022)
* fixed pre-moderation callback flow
* fixed ui bug on cta link screen
* improved permission flow

### 0.1.2 (06.10.2022)
* fixed video playback issue on story upload screen

### 0.1.1 (04.10.2022)
* fixed endpoints to support link cta interactive component 

### 0.1.0 (19.09.2022)
* added video media support for create story for both gallery and camera
* added text interactive component
* added link cta interactive component

### 0.0.8 (12.09.2022)
* added MomentsUserPayload to handle encrytion of user payload in mobile side

### 0.0.7 (16.08.2022)
* IMPORTANT! removed momentsDelegate field from MomentsManager constructor
* IMPORTANT! added momentsDelegete field to MomentsManager

### 0.0.6 (01.07.2022)
* IMPORTANT! renamed StorylyMomentsDelegate to MomentsDelegate

### 0.0.5 (01.06.2022)
* added live photo support for story creation
* improved library update flow for new images
* improved memory usages of library

### 0.0.4 (30.05.2022)
* renamed StorylyMomentsDelegate to MomentsDelegate
* changed text of views and feedbacks

### 0.0.2 (21.04.2022)
* removed benchmark test screen

### 0.0.1 (18.04.2022)
* introduced Moments by Storyly, please check [Moments by Storyly iOS Documentation](https://integration.storyly.io/moments-ios/quick-start.html)
