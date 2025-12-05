package com.storylyplacementreactnative.common


enum class RNPlacementEventType(val eventName: String) {
    // View Events
    ON_PLACEMENT_READY("onPlacementReady"),
    ON_PLACEMENT_FAIL("onPlacementFail"),
    ON_PLACEMENT_EVENT("onPlacementEvent"),
    ON_PLACEMENT_ACTION_CLICKED("onPlacementActionClicked"),
    ON_PLACEMENT_PRODUCT_EVENT("onPlacementProductEvent"),
    ON_PLACEMENT_CART_UPDATE("onPlacementCartUpdate"),
    ON_PLACEMENT_WISHLIST_UPDATE("onPlacementWishlistUpdate"),
    
    // Provider Events
    ON_PROVIDER_LOAD("onProviderLoad"),
    ON_PROVIDER_LOAD_FAIL("onProviderLoadFail"),
    ON_PROVIDER_HYDRATION("onProviderHydration"),
}
