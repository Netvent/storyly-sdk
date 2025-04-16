import { forwardRef, useImperativeHandle, useRef } from "react";
import StorylyNativeView, { Commands, applyBaseEvent } from "./fabric/StorylyReactNativeViewNativeComponent";
import type { STRCart, STRProductItem } from "./data/story";
import type { BaseEvent, ProductEvent, StoryEvent, StoryFailEvent, StoryInteractiveEvent, StoryLoadEvent, StoryPresentFail, StoryPressEvent, StoryProductCartUpdateEvent, StoryProductHydrationEvent, StorySizeChangedEvent, UpdateCustomViewEvent } from "./data/event";
import type { ViewProps } from "react-native";
import { mapStorylyConfig } from "./data/config";
import { STStorylyGroupViewFactory, type StoryGroupViewFactory, type StorylyGroupViewFactoryHandle } from "./StorylyGroupViewFactory";

type StorylyNativeComponentRef = InstanceType<typeof StorylyNativeView>;

export interface StorylyProps extends ViewProps {
    storylyId: string;
    customParameter?: string;
    storylyTestMode?: boolean;
    storylySegments?: string[];
    storylyUserProperty?: Record<string, string>;
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

    storyGroupViewFactory?: StoryGroupViewFactory;

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
    storyProductFeed?: Record<string, STRProductItem[]>;

    storylyLayoutDirection?: "ltr" | "rtl";
    storylyLocale?: string;

    onLoad?: (event: StoryLoadEvent) => void;
    onFail?: (event: StoryFailEvent) => void;
    onStoryOpen?: () => void;
    onStoryOpenFailed?: (event: StoryPresentFail) => void;
    onStoryClose?: () => void;
    onEvent?: (event: StoryEvent) => void;
    onPress?: (event: StoryPressEvent) => void;
    onUserInteracted?: (event: StoryInteractiveEvent) => void;
    onProductHydration?: (event: StoryProductHydrationEvent) => void;
    onCartUpdate?: (event: StoryProductCartUpdateEvent) => void;
    onProductEvent?: (event: ProductEvent) => void;
    onSizeChanged?: (event: StorySizeChangedEvent) => void;
}

export interface StorylyMethods {
    refresh: () => void;
    resumeStory: () => void;
    pauseStory: () => void;
    closeStory: () => void;
    openStory: (url: string) => void;
    openStoryWithId: (groupId: string, storyId?: string, playMode?: string) => void;
    hydrateProducts: (products: STRProductItem[]) => void;
    updateCart: (cart: STRCart) => void;
    approveCartChange: (responseId: string, cart: STRCart) => void;
    rejectCartChange: (responseId: string, failMsg: string) => void;
}

const Storyly = forwardRef<StorylyMethods, StorylyProps>((props, ref) => {

    const storylyRef = useRef<StorylyNativeComponentRef>(null);
    const customGroupRef = useRef<StorylyGroupViewFactoryHandle>(null);

    useImperativeHandle(ref, () => ({
        refresh,
        resumeStory,
        pauseStory,
        closeStory,
        openStory,
        openStoryWithId,
        hydrateProducts,
        updateCart,
        approveCartChange,
        rejectCartChange,
    }));

    const refresh = () => {
        if (storylyRef.current) {
            Commands.refresh(storylyRef.current)
        }
    }


    const resumeStory = () => {
        if (storylyRef.current) {
            Commands.resumeStory(storylyRef.current)
        }
    }

    const pauseStory = () => {
        if (storylyRef.current) {
            Commands.pauseStory(storylyRef.current)
        }
    }

    const closeStory = () => {
        if (storylyRef.current) {
            Commands.closeStory(storylyRef.current)
        }
    }

    const openStory = (url: string) => {
        if (storylyRef.current) {
            Commands.openStory(storylyRef.current, JSON.stringify({ url }))
        }
    }

    const openStoryWithId = (groupId: string, storyId?: string, playMode?: string) => {
        if (storylyRef.current) {
            Commands.openStoryWithId(storylyRef.current, JSON.stringify({ groupId, storyId, playMode }))
        }
    }

    const hydrateProducts = (products: STRProductItem[]) => {
        if (storylyRef.current) {
            Commands.hydrateProducts(storylyRef.current, JSON.stringify({ products }))
        }
    }

    const updateCart = (cart: STRCart) => {
        if (storylyRef.current) {
            Commands.updateCart(storylyRef.current, JSON.stringify({ cart }))
        }
    }

    const approveCartChange = (responseId: string, cart: STRCart) => {
        if (storylyRef.current) {
            Commands.approveCartChange(storylyRef.current, JSON.stringify({ responseId, cart }))
        }
    }

    const rejectCartChange = (responseId: string, failMessage: string) => {
        if (storylyRef.current) {
            Commands.rejectCartChange(storylyRef.current, JSON.stringify({ responseId, failMessage }))
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
        if (props.onStoryOpenFailed) {
            props.onStoryOpenFailed(event as StoryPresentFail);
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

    const _onStorylySizeChanged = (event: BaseEvent) => {
        if (props.onSizeChanged) {
            props.onSizeChanged(event as StorySizeChangedEvent)
        }
    }

    const _onCreateCustomView = (_: BaseEvent) => {
        customGroupRef.current?.onCreateCustomView()
    }

    const _onUpdateCustomView = (event: BaseEvent) => {
        customGroupRef.current?.onUpdateCustomView(event as UpdateCustomViewEvent)
    }

    const storylyConfig = mapStorylyConfig(props)
    return (
        <StorylyNativeView
            {...props}
            ref={storylyRef}
            onStorylyLoaded={applyBaseEvent(_onStorylyLoaded)}
            onStorylyLoadFailed={applyBaseEvent(_onStorylyLoadFailed)}
            onStorylyEvent={applyBaseEvent(_onStorylyEvent)}
            onStorylyActionClicked={applyBaseEvent(_onStorylyActionClicked)}
            onStorylyStoryPresented={applyBaseEvent(_onStorylyStoryPresented)}
            onStorylyStoryPresentFailed={applyBaseEvent(_onStorylyStoryPresentFailed)}
            onStorylyStoryDismissed={applyBaseEvent(_onStorylyStoryDismissed)}
            onStorylyUserInteracted={applyBaseEvent(_onStorylyUserInteracted)}
            onStorylyProductHydration={applyBaseEvent(_onStorylyProductHydration)}
            onStorylyCartUpdated={applyBaseEvent(_onStorylyCartUpdated)}
            onStorylyProductEvent={applyBaseEvent(_onStorylyProductEvent)}
            onStorylySizeChanged={applyBaseEvent(_onStorylySizeChanged)}
            onCreateCustomView={applyBaseEvent(_onCreateCustomView)}
            onUpdateCustomView={applyBaseEvent(_onUpdateCustomView)}
            storylyConfig={storylyConfig} >

            {props.storyGroupViewFactory ?
                <STStorylyGroupViewFactory
                    ref={customGroupRef}
                    key={storylyConfig}
                    width={props.storyGroupViewFactory.width}
                    height={props.storyGroupViewFactory.height}
                    customView={props.storyGroupViewFactory.customView}
                />
                : <></>}
        </StorylyNativeView>
    )
})


export default Storyly;