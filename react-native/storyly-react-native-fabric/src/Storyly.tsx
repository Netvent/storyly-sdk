import React, { useRef } from "react";
import { processColor, type NativeSyntheticEvent } from "react-native";
import { StorylyNativeView, StorylyNativeCommands } from "./StorylyReactNativeViewNativeComponent";
import type { StoryGroup, STRCart, STRProductItem } from "./data/story";
import type { ProductEvent, StoryEvent, StoryFailEvent, StoryInteractiveEvent, StoryLoadEvent, StoryPresentFail, StoryPressEvent, StoryProductCartUpdateEvent, StoryProductHydrationEvent } from "./data/event";

type StorylyNativeComponentRef = InstanceType<typeof StorylyNativeView>;


export interface StoryGroupViewFactory {
    width: number;
    height: number;
    customView: (storyGroup: StoryGroup) => JSX.Element;
}

export type StorylyProps = {
    storylyId: string;
    customParameter?: string;
    storylyTestMode?: boolean;
    storylySegments?: string[];
    storylyUserProperty?: Record<string, string>;
    storylyPayload?: string;
    storylyShareUrl?: string;
    storylyFacebookAppID?: string;

    storyGroupSize?: "small" | "large" | "custom";
    storyGroupAnimation?: "border-rotation" | "disabled";
    storyGroupIconWidth?: number;
    storyGroupIconHeight?: number;
    storyGroupIconCornerRadius?: number;
    storyGroupIconBackgroundColor?: string;
    storyGroupIconBorderColorSeen?: string[];
    storyGroupIconBorderColorNotSeen?: string[];
    storyGroupViewFactory?: StoryGroupViewFactory,

    storyGroupTextSize?: number;
    storyGroupTextLines?: number;
    storyGroupTextColorSeen?: string;
    storyGroupTextColorNotSeen?: string;
    storyGroupTextIsVisible?: boolean;
    storyGroupTextTypeface?: string;
    storyGroupPinIconColor?: string;

    storyGroupListOrientation?: "horizontal" | "vertical";
    storyGroupListSections?: number;
    storyGroupListHorizontalEdgePadding?: number;
    storyGroupListVerticalEdgePadding?: number;
    storyGroupListHorizontalPaddingBetweenItems?: number;
    storyGroupListVerticalPaddingBetweenItems?: number;

    storyItemTextColor?: string;
    storyItemIconBorderColor?: string[];
    storyItemProgressBarColor?: string[];
    storyItemTextTypeface?: string;
    storyInteractiveTextTypeface?: string;

    storyHeaderIconIsVisible?: boolean;
    storyHeaderTextIsVisible?: boolean;
    storyHeaderCloseButtonIsVisible?: boolean;
    storyHeaderCloseIcon?: string;
    storyHeaderShareIcon?: string;

    storyFallbackIsEnabled?: boolean;
    storyCartIsEnabled?: boolean;

    storylyLayoutDirection?: "ltr" | "rtl";

    onLoad?: (event: StoryLoadEvent) => void;
    onFail?: (event: StoryFailEvent) => void;
    onStoryOpen?: () => void;
    onStoryOpenFail?: (event: StoryPresentFail) => void;
    onStoryClose?: () => void;
    onEvent?: (event: StoryEvent) => void;
    onPress?: (event: StoryPressEvent) => void;
    onUserInteracted?: (event: StoryInteractiveEvent) => void;
    onProductHydration?: (event: StoryProductHydrationEvent) => void;
    onCartUpdate?: (event: StoryProductCartUpdateEvent) => void;
    onProductEvent?: (event: ProductEvent) => void;
}

const Storyly: React.FC<StorylyProps> = (props: StorylyProps) => {

    const ref = useRef<StorylyNativeComponentRef>(null);


    /**
     * @deprecated "This function will be removed in v2.3.0. We've introduced the resumeStory() function to story continuation"
     */
    const open = () => {
        if (ref.current) {
            StorylyNativeCommands.open(ref.current)
        }
    }

    const resumeStory = () => {
        if (ref.current) {
            StorylyNativeCommands.resumeStory(ref.current)
        }
    }

    const pauseStory = () => {
        if (ref.current) {
            StorylyNativeCommands.pauseStory(ref.current)
        }
    }

    const closeStory = () => {
        if (ref.current) {
            StorylyNativeCommands.closeStory(ref.current)
        }
    }

    /**
     * @deprecated "This function will be removed in v2.3.0. We've introduced two new functions for improved story management: pauseStory() and closeStory().
     * To temporarily halt a story and later resume it, use pauseStory(), followed by resumeStory() when ready to continue. For an immediate story closure, use closeStory()"
     */
    const close = () => {
        if (ref.current) {
            StorylyNativeCommands.close(ref.current)
        }
    }

    const openStory = (url: string) => {
        if (ref.current) {
            StorylyNativeCommands.openStory(ref.current, url)
        }
    }

    const openStoryWithId = (groupId: string, storyId: String) => {
        if (ref.current) {
            StorylyNativeCommands.openStoryWithId(ref.current, groupId, storyId)
        }
    }

    const hydrateProducts = (products: [STRProductItem]) => {
        if (ref.current) {
            StorylyNativeCommands.hydrateProducts(ref.current, products)
        }
    }

    const updateCart = (cart: STRCart) => {
        if (ref.current) {
            StorylyNativeCommands.updateCart(ref.current, cart)
        }
    }

    const approveCartChange = (responseId: string, cart: STRCart) => {
        if (ref.current) {
            StorylyNativeCommands.approveCartChange(ref.current, responseId, cart)
        }
    }

    const rejectCartChange = (responseId: string, faileMsg: string) => {
        if (ref.current) {
            StorylyNativeCommands.rejectCartChange(ref.current, responseId, faileMsg)
        }
    }


    const _onStorylyLoaded = (event: NativeSyntheticEvent<StoryLoadEvent>) => {
        if (props.onLoad) {
            props.onLoad(event.nativeEvent);
        }
    }

    const _onStorylyLoadFailed = (event: NativeSyntheticEvent<StoryFailEvent>) => {
        if (props.onFail) {
            props.onFail(event.nativeEvent);
        }
    }

    const _onStorylyEvent = (event: NativeSyntheticEvent<StoryEvent>) => {
        if (props.onEvent) {
            props.onEvent(event.nativeEvent);
        }
    }

    const _onStorylyActionClicked = (event: NativeSyntheticEvent<StoryPressEvent>) => {
        if (props.onPress) {
            props.onPress(event.nativeEvent);
        }
    }

    const _onStorylyStoryPresented = () => {
        if (props.onStoryOpen) {
            props.onStoryOpen();
        }
    }

    const _onStorylyStoryPresentFailed = (event: NativeSyntheticEvent<StoryPresentFail>) => {
        if (props.onStoryOpenFail) {
            props.onStoryOpenFail(event.nativeEvent);
        }
    }

    const _onStorylyStoryDismissed = () => {
        if (props.onStoryClose) {
            props.onStoryClose();
        }
    }

    const _onStorylyUserInteracted = (event: NativeSyntheticEvent<StoryInteractiveEvent>) => {
        if (props.onUserInteracted) {
            props.onUserInteracted(event.nativeEvent);
        }
    }

    const _onStorylyProductHydration = (event: NativeSyntheticEvent<StoryProductHydrationEvent>) => {
        if (props.onProductHydration) {
            props.onProductHydration(event.nativeEvent);
        }
    }

    const _onStorylyCartUpdated = (event: NativeSyntheticEvent<StoryProductCartUpdateEvent>) => {
        if (props.onCartUpdate) {
            props.onCartUpdate(event.nativeEvent);
        }
    }

    const _onStorylyProductEvent = (event: NativeSyntheticEvent<ProductEvent>) => {
        if (props.onProductEvent) {
            props.onProductEvent(event.nativeEvent);
        }
    }


    // private _onCreateCustomView = (_) => {
    //     customViewFactoryRef?.onCreateCustomView()
    // }

    // private _onUpdateCustomView = (eventPayload) => {
    //     this.customViewFactoryRef?.onUpdateCustomView(eventPayload.nativeEvent)
    // }

    return (
        <StorylyNativeView
            {...props}
            ref={ref}
            onStorylyLoaded={_onStorylyLoaded}
            onStorylyLoadFailed={_onStorylyLoadFailed}
            onStorylyEvent={_onStorylyEvent}
            onStorylyActionClicked={_onStorylyActionClicked}
            onStorylyStoryPresented={_onStorylyStoryPresented}
            onStorylyStoryPresentFailed={_onStorylyStoryPresentFailed}
            onStorylyStoryClose={_onStorylyStoryDismissed}
            onStorylyUserInteracted={_onStorylyUserInteracted}
            onStorylyProductHydration={_onStorylyProductHydration}
            onStorylyCartUpdated={_onStorylyCartUpdated}
            onStorylyProductEvent={_onStorylyProductEvent}
            // onCreateCustomView={this._onCreateCustomView}
            // onUpdateCustomView={this._onUpdateCustomView}
            storylyConfig={
                {
                    'storylyInit': {
                        'storylyId': props.storylyId,
                        'storylySegments': props.storylySegments,
                        'userProperty': props.storylyUserProperty,
                        'customParameter': props.customParameter,
                        'storylyIsTestMode': props.storylyTestMode,
                        'storylyPayload': props.storylyPayload,
                    },
                    'storyGroupStyling': {
                        'iconBorderColorSeen': props.storyGroupIconBorderColorSeen ? props.storyGroupIconBorderColorSeen.map(processColor) : undefined,
                        'iconBorderColorNotSeen': props.storyGroupIconBorderColorNotSeen ? props.storyGroupIconBorderColorNotSeen.map(processColor) : undefined,
                        'iconBackgroundColor': processColor(props.storyGroupIconBackgroundColor) ?? undefined,
                        'pinIconColor': processColor(props.storyGroupPinIconColor) ?? undefined,
                        'iconHeight': props.storyGroupIconHeight,
                        'iconWidth': props.storyGroupIconWidth,
                        'iconCornerRadius': props.storyGroupIconCornerRadius,
                        'iconBorderAnimation': props.storyGroupAnimation,
                        'titleSeenColor': processColor(props.storyGroupTextColorSeen) ?? undefined,
                        'titleNotSeenColor': processColor(props.storyGroupTextColorNotSeen) ?? undefined,
                        'titleLineCount': props.storyGroupTextLines,
                        'titleFont': props.storyGroupTextTypeface,
                        'titleTextSize': props.storyGroupTextSize,
                        'titleVisible': props.storyGroupTextIsVisible,
                        'groupSize': props.storyGroupSize,
                    },
                    'storyGroupViewFactory': {
                        'width': props.storyGroupViewFactory ? props.storyGroupViewFactory.width : 0,
                        'height': props.storyGroupViewFactory ? props.storyGroupViewFactory.height : 0,
                    },
                    'storyBarStyling': {
                        'orientation': props.storyGroupListOrientation,
                        'sections': props.storyGroupListSections,
                        'horizontalEdgePadding': props.storyGroupListHorizontalEdgePadding,
                        'verticalEdgePadding': props.storyGroupListVerticalEdgePadding,
                        'horizontalPaddingBetweenItems': props.storyGroupListHorizontalPaddingBetweenItems,
                        'verticalPaddingBetweenItems': props.storyGroupListVerticalPaddingBetweenItems,
                    },
                    'storyStyling': {
                        'headerIconBorderColor': props.storyItemIconBorderColor ? props.storyItemIconBorderColor.map(processColor) : undefined,
                        'titleColor': processColor(props.storyItemTextColor) ?? undefined,
                        'titleFont': props.storyItemTextTypeface,
                        'interactiveFont': props.storyInteractiveTextTypeface,
                        'progressBarColor': props.storyItemProgressBarColor ? props.storyItemProgressBarColor.map(processColor) : undefined,
                        'isTitleVisible': props.storyHeaderTextIsVisible,
                        'isHeaderIconVisible': props.storyHeaderIconIsVisible,
                        'isCloseButtonVisible': props.storyHeaderCloseButtonIsVisible,
                        'closeButtonIcon': props.storyHeaderCloseIcon,
                        'shareButtonIcon': props.storyHeaderShareIcon,
                    },
                    'storyShareConfig': {
                        'storylyShareUrl': props.storylyShareUrl,
                        'storylyFacebookAppID': props.storylyFacebookAppID,
                    },
                    'storyProductConfig': {
                        'isFallbackEnabled': props.storyFallbackIsEnabled,
                        'isCartEnabled': props.storyCartIsEnabled,
                    },
                    'storylyLayoutDirection': props.storylyLayoutDirection,
                }
            } >
            {/* {storyGroupViewFactory ?
                <STStorylyGroupViewFactory
                    ref={(ref) => { this.customViewFactoryRef = ref }}
                    width={storyGroupViewFactory.width}
                    height={storyGroupViewFactory.height}
                    CustomizedView={storyGroupViewFactory.customView} /> : <></>} */}
        </StorylyNativeView>
    )
}

export default Storyly;