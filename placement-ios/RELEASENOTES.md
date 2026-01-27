# Release Notes
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
