import React, { Component, useState, forwardRef, useImperativeHandle } from 'react';
import {
    requireNativeComponent,
    UIManager,
    findNodeHandle,
    processColor,
} from 'react-native';
import { string, arrayOf, func, number, bool, object } from 'prop-types';

class VerticalFeedBar extends Component {
    refresh = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._verticalFeedBarView),
            UIManager.getViewManagerConfig('STVerticalFeedBar').Commands.refresh,
            [],
        );
    };

    resumeStory = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._verticalFeedBarView),
            UIManager.getViewManagerConfig('STVerticalFeedBar').Commands.resumeStory,
            [],
        );
    };

    pauseStory = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._verticalFeedBarView),
            UIManager.getViewManagerConfig('STVerticalFeedBar').Commands.pauseStory,
            [],
        );
    };

    closeStory = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._verticalFeedBarView),
            UIManager.getViewManagerConfig('STVerticalFeedBar').Commands.closeStory,
            [],
        );
    };

    openStory = (payload) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._verticalFeedBarView),
            UIManager.getViewManagerConfig('STVerticalFeedBar').Commands.openStory,
            [payload],
        );
    };

    openStoryWithId = (storyGroupId, storyId, playMode) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._verticalFeedBarView),
            UIManager.getViewManagerConfig('STVerticalFeedBar').Commands.openStoryWithId,
            [storyGroupId, storyId, playMode],
        );
    };

    hydrateProducts = (products) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._verticalFeedBarView),
            UIManager.getViewManagerConfig('STVerticalFeedBar').Commands.hydrateProducts,
            [products],
        );
    }

    updateCart = (cart) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._verticalFeedBarView),
            UIManager.getViewManagerConfig('STVerticalFeedBar').Commands.updateCart,
            [cart],
        );
    }

    approveCartChange = (responseId, cart) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._verticalFeedBarView),
            UIManager.getViewManagerConfig('STVerticalFeedBar').Commands.approveCartChange,
            [responseId, cart],
        );
    }

    rejectCartChange = (responseId, failMessage) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._verticalFeedBarView),
            UIManager.getViewManagerConfig('STVerticalFeedBar').Commands.rejectCartChange,
            [responseId, failMessage],
        );
    }

    _onStorylyLoaded = (eventPayload) => {
        if (this.props.onLoad) {
            this.props.onLoad(eventPayload.nativeEvent);
        }
    }

    _onStorylyLoadFailed = (eventPayload) => {
        if (this.props.onFail) {
            this.props.onFail(eventPayload.nativeEvent);
        }
    }

    _onStorylyEvent = (eventPayload) => {
        if (this.props.onEvent) {
            this.props.onEvent(eventPayload.nativeEvent);
        }
    }

    _onStorylyActionClicked = (eventPayload) => {
        if (this.props.onPress) {
            this.props.onPress(eventPayload.nativeEvent);
        }
    }

    _onStorylyVerticalFeedPresented = (eventPayload) => {
        if (this.props.onVerticalFeedOpen) {
            this.props.onVerticalFeedOpen();
        }
    }

    _onStorylyVerticalFeedPresentFailed = (eventPayload) => {
        if (this.props.onVerticalFeedOpenFailed) {
            this.props.onVerticalFeedOpenFailed(eventPayload.nativeEvent);
        }
    }

    _onStorylyVerticalFeedDismissed = (eventPayload) => {
        if (this.props.onVerticalFeedClose) {
            this.props.onVerticalFeedClose();
        }
    }

    _onStorylyUserInteracted = (eventPayload) => {
        if (this.props.onUserInteracted) {
            this.props.onUserInteracted(eventPayload.nativeEvent);
        }
    }
    
    _onStorylyProductHydration = (eventPayload) => {
        if (this.props.onProductHydration) {
            this.props.onProductHydration(eventPayload.nativeEvent);
        }
    }

    _onStorylyCartUpdated = (eventPayload) => {
        if (this.props.onCartUpdate) {
            this.props.onCartUpdate(eventPayload.nativeEvent);
        }
    }

    _onStorylyProductEvent = (eventPayload) => {
        if (this.props.onProductEvent) {
            this.props.onProductEvent(eventPayload.nativeEvent);
        }
    }

    render() {
        const {
            storylyId,
            storylySegments,
            storylyUserProperty,
            customParameter,
            storylyTestMode,
            storylyShareUrl,
            storylyFacebookAppID,
            verticalFeedGroupIconHeight,
            verticalFeedGroupIconCornerRadius,
            verticalFeedGroupListSections,
            verticalFeedGroupListHorizontalEdgePadding,
            verticalFeedGroupListVerticalEdgePadding,
            verticalFeedGroupListHorizontalPaddingBetweenItems,
            verticalFeedGroupListVerticalPaddingBetweenItems,
            verticalFeedGroupTextIsVisible,
            verticalFeedGroupOrder,
            verticalFeedGroupMinLikeCountToShowIcon,
            verticalFeedGroupMinImpressionCountToShowIcon,
            verticalFeedGroupImpressionIcon,
            verticalFeedGroupLikeIcon,
            verticalFeedGroupTextTypeface,
            verticalFeedGroupTextSize,
            verticalFeedGroupTextColor,
            verticalFeedTypeIndicatorIsVisible,
            verticalFeedGroupIconBackgroundColor,
            storylyLayoutDirection,
            storylyLocale,
            verticalFeedItemProgressBarColor,
            verticalFeedItemProgressBarVisibility,
            verticalFeedItemTextTypeface,
            verticalFeedItemInteractiveTextTypeface,
            verticalFeedItemTitleVisibility,
            verticalFeedItemCloseButtonIsVisible,
            verticalFeedItemLikeButtonIsVisible,
            verticalFeedItemShareButtonIsVisible,
            verticalFeedItemCloseIcon,
            verticalFeedItemShareIcon,
            verticalFeedItemLikeIcon,
            verticalFeedFallbackIsEnabled,
            verticalFeedCartIsEnabled,
            verticalFeedProductFeed,
            ...otherProps
        } = this.props;
        const storylyConfig = {
            'storylyInit': {
                'storylyId': storylyId,
                'storylySegments': storylySegments,
                'userProperty': storylyUserProperty,
                'customParameter': customParameter,
                'storylyIsTestMode': storylyTestMode, 
                'storylyLayoutDirection': storylyLayoutDirection,
                'storylyLocale': storylyLocale,
            },
            'verticalFeedGroupStyling': {
                'iconBackgroundColor': processColor(verticalFeedGroupIconBackgroundColor),
                'iconCornerRadius': verticalFeedGroupIconCornerRadius,
                'iconHeight': verticalFeedGroupIconHeight, 
                'textColor': processColor(verticalFeedGroupTextColor), 
                'titleFont': verticalFeedGroupTextTypeface, 
                'titleTextSize': verticalFeedGroupTextSize,  
                'titleVisible': verticalFeedGroupTextIsVisible, 
                'groupOrder': verticalFeedGroupOrder,
                'typeIndicatorVisible': verticalFeedTypeIndicatorIsVisible,
                'minLikeCountToShowIcon': verticalFeedGroupMinLikeCountToShowIcon,
                'minImpressionCountToShowIcon': verticalFeedGroupMinImpressionCountToShowIcon,
                'impressionIcon': verticalFeedGroupImpressionIcon,
                'likeIcon': verticalFeedGroupLikeIcon,
            },
            'verticalFeedBarStyling': {
                'sections': verticalFeedGroupListSections,
                'horizontalEdgePadding': verticalFeedGroupListHorizontalEdgePadding,
                'verticalEdgePadding': verticalFeedGroupListVerticalEdgePadding,
                'horizontalPaddingBetweenItems': verticalFeedGroupListHorizontalPaddingBetweenItems,
                'verticalPaddingBetweenItems': verticalFeedGroupListVerticalPaddingBetweenItems,
            },
            'verticalFeedCustomization': { 
                'titleFont': verticalFeedItemTextTypeface,
                'interactiveFont': verticalFeedItemInteractiveTextTypeface,
                'progressBarColor': verticalFeedItemProgressBarColor ? verticalFeedItemProgressBarColor.map(processColor) : null,
                'isTitleVisible': verticalFeedItemTitleVisibility,
                'isCloseButtonVisible': verticalFeedItemCloseButtonIsVisible,
                'islikeButtonVisible': verticalFeedItemLikeButtonIsVisible,
                'isShareButtonVisible': verticalFeedItemShareButtonIsVisible,
                'closeButtonIcon': verticalFeedItemCloseIcon,
                'shareButtonIcon': verticalFeedItemShareIcon,
                "likeButtonIcon": verticalFeedItemLikeIcon,
                'isProgressBarVisible': verticalFeedItemProgressBarVisibility,
            },
            'verticalFeedItemShareConfig': {
                'storylyShareUrl': storylyShareUrl,
                'storylyFacebookAppID': storylyFacebookAppID,
            },
            'verticalFeedItemProductConfig': { 
                'isFallbackEnabled': verticalFeedFallbackIsEnabled,
                'isCartEnabled': verticalFeedCartIsEnabled,
                'productFeed': verticalFeedProductFeed,
            },
        }


        return (
            <STVerticalFeedBar
                {...otherProps}
                onStorylyLoaded={this._onStorylyLoaded}
                onStorylyLoadFailed={this._onStorylyLoadFailed}
                onStorylyEvent={this._onStorylyEvent}
                onStorylyActionClicked={this._onStorylyActionClicked}
                onStorylyStoryPresented={this._onStorylyVerticalFeedPresented}
                onStorylyStoryPresentFailed={this._onStorylyVerticalFeedPresentFailed}
                onStorylyStoryDismissed={this._onStorylyVerticalFeedDismissed}
                onStorylyUserInteracted={this._onStorylyUserInteracted}
                onStorylyProductHydration={this._onStorylyProductHydration} 
                onStorylyCartUpdated={this._onStorylyCartUpdated} 
                onStorylyProductEvent={this._onStorylyProductEvent}
                storyly={ storylyConfig }
                ref={el => (this._verticalFeedBarView = el)}>
            </STVerticalFeedBar>
        )
    }
}

VerticalFeedBar.propTypes = {
    storylyId: string.isRequired,
    storylySegments: arrayOf(string),
    storylyUserProperty: object,
    customParameter: string,
    storylyTestMode: bool,
    storylyShareUrl: string,

    verticalFeedGroupIconBackgroundColor: string,
    verticalFeedGroupTextIsVisible: bool,
    verticalFeedGroupOrder: string,
    verticalFeedGroupTextTypeface: string,
    verticalFeedGroupTextSize: number,
    verticalFeedGroupIconHeight: number,
    verticalFeedGroupIconCornerRadius: number,
    verticalFeedGroupTextColor: string,
    verticalFeedGroupMinLikeCountToShowIcon: number,
    verticalFeedGroupMinImpressionCountToShowIcon: number,
    verticalFeedGroupImpressionIcon: string,
    verticalFeedGroupLikeIcon: string,
    verticalFeedTypeIndicatorIsVisible: bool,

    verticalFeedGroupListSections: number,
    verticalFeedGroupListHorizontalEdgePadding: number,
    verticalFeedGroupListVerticalEdgePadding: number,
    verticalFeedGroupListHorizontalPaddingBetweenItems: number,
    verticalFeedGroupListVerticalPaddingBetweenItems: number,

    verticalFeedItemProgressBarColor: arrayOf(string),
    verticalFeedItemProgressBarVisibility: bool,
    verticalFeedItemLikeButtonIsVisible: bool,
    verticalFeedItemShareButtonIsVisible: bool,
    verticalFeedItemTextTypeface: string,
    verticalFeedItemInteractiveTextTypeface: string,
    verticalFeedItemTitleVisibility: bool,
    verticalFeedItemCloseButtonIsVisible: bool,
    verticalFeedItemCloseIcon: string,
    verticalFeedItemShareIcon: string,
    verticalFeedItemLikeIcon: string,

    storylyLayoutDirection: string,
    verticalFeedFallbackIsEnabled: bool,
    verticalFeedCartIsEnabled: bool,
    verticalFeedProductFeed: object,

    onLoad: func,
    onFail: func,
    onPress: func,
    onEvent: func,
    onVerticalFeedOpen: func,
    onVerticalFeedOpenFailed: func,
    onVerticalFeedClose: func,
    onUserInteracted: func,
    onProductHydration: func,
    onCartUpdate: func,
    onProductEvent: func,
}

const STVerticalFeedBar = requireNativeComponent('STVerticalFeedBar', null);
const STVerticalFeedBarGroupView = requireNativeComponent('STVerticalFeedBarGroupView', null);

export default VerticalFeedBar;
