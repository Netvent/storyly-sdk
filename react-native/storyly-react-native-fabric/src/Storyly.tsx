import React, { useRef } from "react";
import { processColor } from "react-native";
import StorylyNativeView, { StorylyNativeCommands, applyBaseEvent } from "./StorylyReactNativeNativeComponent";
import type { StoryGroup, STRCart, STRProductItem } from "./data/story";
import type { BaseEvent, ProductEvent, StoryEvent, StoryFailEvent, StoryInteractiveEvent, StoryLoadEvent, StoryPresentFail, StoryPressEvent, StoryProductCartUpdateEvent, StoryProductHydrationEvent } from "./data/event";
import type { ViewProps } from "react-native";

type StorylyNativeComponentRef = InstanceType<typeof StorylyNativeView>;


export interface StoryGroupViewFactory {
    width: number;
    height: number;
    customView: React.FC<{storyGroup: StoryGroup}>;
}

export interface StorylyProps extends ViewProps {
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

const mapStorylyConfig = (props: StorylyProps) => {
    return {
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
}

const Storyly: React.FC<StorylyProps> = (props: StorylyProps) => {

    const ref = useRef<StorylyNativeComponentRef>(null);

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

    const openStory = (url: string) => {
        if (ref.current) {
            StorylyNativeCommands.openStory(ref.current, JSON.stringify({url}))
        }
    }

    const openStoryWithId = (groupId: string, storyId: string) => {
        if (ref.current) {
            StorylyNativeCommands.openStoryWithId(ref.current, JSON.stringify({groupId, storyId}))
        }
    }

    const hydrateProducts = (products: [STRProductItem]) => {
        if (ref.current) {
            StorylyNativeCommands.hydrateProducts(ref.current, JSON.stringify({products}))
        }
    }

    const updateCart = (cart: STRCart) => {
        if (ref.current) {
            StorylyNativeCommands.updateCart(ref.current, JSON.stringify({cart}))
        }
    }

    const approveCartChange = (responseId: string, cart: STRCart) => {
        if (ref.current) {
            StorylyNativeCommands.approveCartChange(ref.current, JSON.stringify({responseId, cart}))
        }
    }

    const rejectCartChange = (responseId: string, faileMsg: string) => {
        if (ref.current) {
            StorylyNativeCommands.rejectCartChange(ref.current, JSON.stringify({responseId, faileMsg}))
        }
    }


    const _onStorylyLoaded = (event: BaseEvent) => {
        if (props.onLoad) {
            props.onLoad(event as StoryLoadEvent);
        }
    }

    const _onStorylyLoadFailed = (event: BaseEvent) => {
        if (props.onFail) {
            props.onFail(event as StoryFailEvent);
        }
    }

    const _onStorylyEvent = (event: BaseEvent) => {
        if (props.onEvent) {
            props.onEvent(event as StoryEvent);
        }
    }

    const _onStorylyActionClicked = (event: BaseEvent) => {
        if (props.onPress) {
            props.onPress(event as StoryPressEvent)
        }
    }

    const _onStorylyStoryPresented = (_: BaseEvent) => {
        if (props.onStoryOpen) {
            props.onStoryOpen();
        }
    }

    const _onStorylyStoryPresentFailed = (event: BaseEvent) => {
        if (props.onStoryOpenFail) {
            props.onStoryOpenFail(event as StoryPresentFail);
        }
    }

    const _onStorylyStoryDismissed = (_: BaseEvent) => {
        if (props.onStoryClose) {
            props.onStoryClose();
        }
    }

    const _onStorylyUserInteracted = (event: BaseEvent) => {
        if (props.onUserInteracted) {
            props.onUserInteracted(event as StoryInteractiveEvent);
        }
    }

    const _onStorylyProductHydration = (event: BaseEvent) => {
        if (props.onProductHydration) {
            props.onProductHydration(event as StoryProductHydrationEvent);
        }
    }

    const _onStorylyCartUpdated = (event: BaseEvent) => {
        if (props.onCartUpdate) {
            props.onCartUpdate(event as StoryProductCartUpdateEvent);
        }
    }

    const _onStorylyProductEvent = (event: BaseEvent) => {
        if (props.onProductEvent) {
            props.onProductEvent(event as ProductEvent);
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
            onStorylyLoaded={applyBaseEvent(_onStorylyLoaded)}
            onStorylyLoadFailed={applyBaseEvent(_onStorylyLoadFailed)}
            onStorylyEvent={applyBaseEvent(_onStorylyEvent)}
            onStorylyActionClicked={applyBaseEvent(_onStorylyActionClicked)}
            onStorylyStoryPresented={applyBaseEvent(_onStorylyStoryPresented)}
            onStorylyStoryPresentFailed={applyBaseEvent(_onStorylyStoryPresentFailed)}
            onStorylyStoryClose={applyBaseEvent(_onStorylyStoryDismissed)}
            onStorylyUserInteracted={applyBaseEvent(_onStorylyUserInteracted)}
            onStorylyProductHydration={applyBaseEvent(_onStorylyProductHydration)}
            onStorylyCartUpdated={applyBaseEvent(_onStorylyCartUpdated)}
            onStorylyProductEvent={applyBaseEvent(_onStorylyProductEvent)}
            // onCreateCustomView={this._onCreateCustomView}
            // onUpdateCustomView={this._onUpdateCustomView}
            storylyConfig={JSON.stringify(mapStorylyConfig(props))} >
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