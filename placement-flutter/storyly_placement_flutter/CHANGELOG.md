# Release Notes

### 1.3.2 (29.01.2026)
* removed cart integration
* removed development endpoints from codebase
* added dots as progress style for banner widget
* added new enumeration for product events
* fixed a bug related to dots progress when autoplay is enabled for banner widget
* fixed story resume upon go to cart button click in success sheet on android platform
* fixed a crash in case of empty data rendering for video feed widget on ios platform
* fixed a resume issue of banner slides when story/video feed presenter is dismissed from a flow on ios platform
* fixed wishlist functionality on ios platform
* changed onUpdateCart listener method signature
* changed hydrateWishlist method signature
* renamed PlacementDataProvider to STRPlacementDataProvider
* renamed STRProviderListener to STRDataProviderListener on android platform
* renamed STRProviderProductListener to STRDataProviderProductListener on android platform
* renamed STRProviderDelegate to STRDataProviderDelegate on ios platform
* renamed STRProviderProductDelegate to STRDataProviderDelegate ios android platform
* renamed ProductCartAdded, ProductCartAddFailed, CartButtonClicked to ProductAddToCartSuccess, ProductAddToCartFail, GoToCartButtonClicked respectively
* removed ProductAdded event
* removed price fields from STRCartItem
* removed product fallback configuration
* removed CardActionClicked product event for swipe card widget

### 1.2.1 (16.01.2026)
* added storyly placement sdk
* added storyly swipe card widget
* added storyly banner widget
* added storyly story bar widget
* added storyly video feed widget
* added storyly canvas widget