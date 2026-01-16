package com.storylyplacementreactnative.common


enum class SPPlacementEventType(val eventName: String) {
    ON_WIDGET_READY("onWidgetReady"),
    ON_FAIL("onFail"),
    ON_EVENT("onEvent"),
    ON_ACTION_CLICKED("onActionClicked"),
    ON_PRODUCT_EVENT("onProductEvent"),
    ON_UPDATE_CART("onUpdateCart"),
    ON_UPDATE_WISHLIST("onUpdateWishlist"),
}
