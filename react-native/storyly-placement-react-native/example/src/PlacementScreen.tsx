import { useEffect, useState, useRef } from "react";
import { View, Button, Dimensions, StyleSheet } from "react-native";
import {  type StorylyPlacementConfig, type StorylyPlacementProviderListener, useStorylyPlacementProvider, type StorylyPlacementMethods, type PlacementWidget, StorylyPlacement, type PlacementCartUpdateEvent, type STRProductItem, type STRProductInformation, StorylyAnalytics, STRAnalyticProductEvent } from "storyly-placement-react-native";


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

            // const infos: STRProductInformation[] = event.products.map(product => ({
            //     productId: product.productId ?? "",
            //     productGroupId: product.productGroupId ?? "",
            // } as STRProductInformation));
            // provider.hydrateWishlist(infos);

        },
    };

    const provider = useStorylyPlacementProvider(placementConfig, placementListener);
    const placementRef = useRef<StorylyPlacementMethods>(null);

    // Initialize the standalone Storyly Analytics module once.
    useEffect(() => {
        StorylyAnalytics.initialize({ token: token, userId: 'demo-user' });
    }, [token]);

    const [placementHeight, setPlacementHeight] = useState<number>(0);
    const [pauseWidget, setPauseWidget] = useState<PlacementWidget | null>(null);


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
                    placementRef.current?.getWidget(event.widget).pause();
                    setPauseWidget(event.widget);
                    console.log(`[${name}] onActionClicked`, event);
                }}
                onEvent={(event) => { console.log(`[${name}] onEvent`, event); }}
                onFail={(event) => { console.log(`[${name}] onFail`, event); }}
                onVisibilityChange={(event) => { console.log(`[${name}] onVisibilityChange`, event.isVisible); }}
                onProductEvent={(event) => { console.log(`[${name}] onProductEvent`, event); }}
                onUpdateCart={(event: PlacementCartUpdateEvent) => {
                    console.log(`[${name}] onUpdateCart`, event, event.item);
                    placementRef?.current?.approveCartChange(event.responseId);
                    placementRef?.current?.rejectCartChange(event.responseId, "test");
                }}
                onUpdateWishlist={(event) => {
                    console.log(`[${name}] onUpdateWishlist`, event);
                    placementRef?.current?.approveWishlistChange(event.responseId);
                    // placementRef?.current?.rejectWishlistChange(event.responseId, "test");
                }}
            />
            <Button title={`Resume Paused Widget`} onPress={() => {
                if (pauseWidget) {
                    placementRef.current?.getWidget(pauseWidget).resume();
                    setPauseWidget(null);
                }
            }} />
            <Button title={`Track Analytics Event`} onPress={() => {
                StorylyAnalytics.trackProduct(STRAnalyticProductEvent.WishlistAdded, {
                    productId: 'product-1',
                    productGroupId: 'group-1',
                    title: 'Demo Product',
                    desc: 'A product tracked from the analytics demo',
                    price: 99.9,
                    salesPrice: 79.9,
                    quantity: 2,
                });
                console.log(`[${name}] tracked PDPViewed analytics event`);
            }} />
        </View>
    );
};

const styles = StyleSheet.create({
    screenContainer: {
        flex: 1,
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'flex-start',
    },

})