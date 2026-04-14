# Release Notes
### 1.7.1 (14.04.2026)
* fixed close button visibility for video feed widget
* fixed impression/like icon layouts for video feed widget

### 1.7.0 (10.04.2026)
* added design settings for video feed widget
* added visibility support for cart button in swipe card widget
* added canvas to story bar presenter flow
* added canvas to video feed presenter flow
* improved reset logic of canvas widget
* improved avplayers to prevent/allow device sleep
* fixed static test mode parameter

### 1.6.0 (01.04.2026)
* improved pause/resume flow story bar widget
* improved pause/resume flow video feed widget
* improved corner radius logic for buttons in banner widget
* improved corner radius logic for media in canvas widget
* added support for google fonts for banner widget buttons
* added media ratio logic for canvas widget
* added horizontal and vertical paddings for canvas widget
  
### 1.5.0 (19.03.2026)
* added onVisibilityChange delegate method to STRDelegate
* added pause/resume/open functions to STRWidgetController
  
### 1.4.2 (12.03.2026)
* improved click handling on banner widget

### 1.4.1 (11.03.2026)
* improved data queue manager
* improved video observers for story bar and video feed widgets
* improved gradients of product catalog interactive component for video feed widget
* fixed interactive component animation glitch on initial load of the video feed presenter
* fixed interactive component animation glitch on initial load of the story bar presenter
* renamed PlayMode to STRStoryBarPlayMode for story bar widget
* renamed VFPlayMode to STRVideoFeedPlayMode for video feed widget
* renamed StoryShowFailed to FeedShowFailed for video feed widget
  
### 1.4.0 (16.02.2026)
* added video support for banner widget
* added RTL layout direction support for banner widget
* added widget controller extensions to simplify specific widget controller access
* updated default autoplay duration for banner widget
* fixed a visual bug for the first feed of video feed presenter
* fixed a bug related to background color of swipe up interactive component
  
### 1.3.1 (27.01.2026)
* fixed a bug related to dots progress when autoplay is enabled for banner widget
* fixed a crash in case of empty data rendering for video feed widget
* fixed a resume issue of banner slides when story/video feed presenter is dismissed from a flow
* removed internal cart integration logic from codebase
* removed development endpoints from codebase
  
### 1.3.0 (22.01.2026)
* added dots as progress style for banner widget
* added new enumeration for product events
* fixed wishlist functionality 
* changed onUpdateCart listener method signature
* changed hydrateWishlist method signature
* renamed PlacementDataProvider to STRPlacementDataProvider
* renamed STRProviderDelegate to STRDataProviderDelegate
* renamed STRProviderProductDelegate to STRDataProviderDelegate
* renamed ProductCartAdded, ProductCartAddFailed, CartButtonClicked to ProductAddToCartSuccess, ProductAddToCartFail, GoToCartButtonClicked respectively
* removed ProductAdded event
* removed price fields from STRCartItem
* removed cart integration
* removed product fallback configuration
* removed CardActionClicked product event for swipe card widget

### 1.2.1 (13.01.2026)
* fixed a bug related to video feed presenter layouting
* fixed memory leaks
* improved video feed tutorial view present logic

### 1.2.0 (07.01.2026)
* added storyly canvas widget
* added etag handling for Not Modified network responses
* improved style and size data structure for each widget
* improved story transition handling in case of layer fails for story bar widget
* improved widget scale logic
* fixed capitalization in German localization
* fixed a bug related banner to video feed flow

### 1.1.0 (03.12.2025)
* added play/pause/replay accesibility controls for stories
* fixed a bug related to swipe interactive component background color
  
### 1.0.0 (26.11.2025)
* added storyly analytics module
* added flow for banner to video feed
* added lowest price availability for eu regulations for product related interactive components
* added auto alignment for text component to align texts based on layout direction in StorylyConfig
* synchronized asset naming with android sdk
* removed pointer icon to increase price text area in product card interactive component
  
### 0.0.1 (15.10.2025)
* added storyly placement sdk
* added storyly swipe card widget
* added storyly banner widget
* added storyly story bar widget
* added storyly video feed widget
