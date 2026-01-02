import { useState, useRef } from "react";
import { View, Button, Dimensions, StyleSheet } from "react-native";
import { type STRCart, type StorylyPlacementConfig, type StorylyPlacementProviderListener, useStorylyPlacementProvider, type StorylyPlacementMethods, type PlacementWidget, type STRCartItem, StorylyPlacement, type STRStoryBarController, type PlacementCartUpdateEvent, type STRVideoFeedController, type STRProductItem } from "storyly-placement-react-native";


const screenWidth = Dimensions.get('window').width;


export const PlacementScreen = ({ name, token }: { name: string, token: string }) => {


    const placementConfig: StorylyPlacementConfig = {
        token: token,
        testMode: true,
        productConfig: {
            isFallbackEnabled: true,
            isCartEnabled: true,
        },
        shareConfig: {
            shareUrl: 'https://www.google.com',
            facebookAppId: '1234567890',
        },
    }

    const placementListener: StorylyPlacementProviderListener = {
        onLoad: (event) => { console.log(`[${name}] onLoad`, event); },
        onLoadFail: (event) => { console.log(`[${name}] onLoadFail`, event); },
        onHydration: (event) => { 
            console.log(`[${name}] onHydration`, event);
            // const products: STRProductItem[] = event.products.map(product => ({
            //     productId: product.productId ?? "",
            //     productGroupId: product.productGroupId ?? "",
            //     title: "TITLE",
            //     desc: "DESCRIPTION",
            //     price: 80,
            //     salesPrice: 99,
            //     lowestPrice: 0,
            //     currency: "USD",
            //     url: "",
            //     imageUrls: ["https://via.placeholder.com/150"],
            //     variants: [{ name: "COLOR", value: "RED", key: "color_red" }],
            //     ctaText: "",
            // } as STRProductItem));
            // provider.hydrateProducts(products)
        },
    };

    const provider = useStorylyPlacementProvider(placementConfig, placementListener);
    const placementRef = useRef<StorylyPlacementMethods>(null);

    const [placementHeight, setPlacementHeight] = useState<number>(0);
    const [pauseWidget, setPauseWidget] = useState<PlacementWidget | null>(null);

    const [cart, setCart] = useState<STRCart>({ items: [], totalPrice: 0, currency: 'USD' });


    return (
        <View style={styles.screenContainer}>
            <StorylyPlacement
                style={{ height: placementHeight, width: "100%", backgroundColor: 'lightgray' }}
                ref={placementRef}
                provider={provider}
                onWidgetReady={(event) => {
                    setPlacementHeight(screenWidth / event.ratio);
                    console.log(`[${name}] onWidgetReady`, event, 'calculated height:', placementHeight);
                }}
                onActionClicked={(event) => {
                    if (event.widget.type === 'story-bar' || event.widget.type === 'video-feed') {
                        placementRef.current?.getWidget<STRStoryBarController | STRVideoFeedController>(event.widget).pause();
                        setPauseWidget(event.widget);
                    }
                    console.log(`[${name}] onActionClicked`, event);
                }}
                onEvent={(event) => { console.log(`[${name}] onEvent`, event); }}
                onFail={(event) => { console.log(`[${name}] onFail`, event); }}
                onProductEvent={(event) => { console.log(`[${name}] onProductEvent`, event); }}
                onUpdateCart={(event: PlacementCartUpdateEvent) => {
                    console.log(`[${name}] onUpdateCart`, event);
                    if (event.change) {
                        const updatedCart = updateCart(cart, event.change, event.event);
                        setCart(updatedCart);
                        placementRef?.current?.approveCartChange(event.responseId, updatedCart);
                    }
                }}
                onUpdateWishlist={(event) => { console.log(`[${name}] onUpdateWishlist`, event); }}
            />
            <Button title={`Resume Paused Widget`} onPress={() => {
                if (pauseWidget) {
                    placementRef.current?.getWidget<STRStoryBarController | STRVideoFeedController>(pauseWidget).resume();
                    setPauseWidget(null);
                }
            }} />
        </View>
    );
};

const updateCart = (cart: STRCart, change: STRCartItem, eventName: string): STRCart => {
    const productId = change.item.productId;
    console.log(`updateCart: event=${eventName}, productId=${productId}, quantity=${change.quantity}`);

    const currentItems = [...cart.items];
    const existingItemIndex = currentItems.findIndex(item => item.item.productId === productId);

    const handleProductAdded = () => {
        if (existingItemIndex !== -1) {
            currentItems[existingItemIndex] = change;
            console.log(`Updated existing item: ${change.item.productId}`);
        } else {
            currentItems.push(change);
            console.log(`Added new item: ${change.item.productId}`);
        }
    };

    const handleProductUpdated = () => {
        if (existingItemIndex !== -1) {
            currentItems[existingItemIndex] = change;
            console.log(`Updated item: ${change.item.productId}`);
        } else {
            currentItems.push(change);
            console.log(`Product not found for update, adding: ${change.item.productId}`);
        }
    };

    const handleProductRemoved = () => {
        if (existingItemIndex !== -1) {
            currentItems.splice(existingItemIndex, 1);
            console.log(`Removed item: ${productId}`);
        } else {
            console.log(`Product not found for removal: ${productId}`);
        }
    };

    const handleUnknownEvent = () => {
        if (existingItemIndex !== -1) {
            if (change.quantity <= 0) {
                currentItems.splice(existingItemIndex, 1);
                console.log(`Removed item (quantity<=0)`);
            } else {
                currentItems[existingItemIndex] = change;
                console.log(`Updated item`);
            }
        } else if (change.quantity > 0) {
            currentItems.push(change);
            console.log(`Added new item`);
        }
    };

    switch (eventName) {
        case "StoryProductAdded":
        case "VideoFeedItemProductAdded":
            handleProductAdded();
            break;
        case "StoryProductUpdated":
        case "VideoFeedItemProductUpdated":
            handleProductUpdated();
            break;
        case "StoryProductRemoved":
        case "VideoFeedItemProductRemoved":
            handleProductRemoved();
            break;
        default:
            handleUnknownEvent();
            break;
    }

    const totalPrice = currentItems.reduce((sum, item) => sum + (item.totalPrice || 0), 0);
    const updatedCart: STRCart = {
        items: currentItems,
        totalPrice: totalPrice,
        oldTotalPrice: undefined,
        currency: change.item.currency || 'USD'
    };
    console.log(`Cart updated: ${currentItems.length} items, total=${totalPrice}`);
    return updatedCart;
};

const styles = StyleSheet.create({
    screenContainer: {
        flex: 1,
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'flex-start',
    },

})