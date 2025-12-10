package com.storylyplacementreactnative.common


enum class RNPlacementEventType(val eventName: String) {
    ON_WIDGET_READY("onWidgetReady"),
    ON_FAIL("onFail"),
    ON_EVENT("onEvent"),
    ON_ACTION_CLICKED("onActionClicked"),
    ON_PRODUCT_EVENT("onProductEvent"),
    ON_CART_UPDATE("onCartUpdate"),
    ON_WISHLIST_UPDATE("onWishlistUpdate"),
}
