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
        if (this.props.onStoryOpen) {
            this.props.onStoryOpen();
        }
    }

    _onStorylyVerticalFeedPresentFailed = (eventPayload) => {
        if (this.props.onStoryOpenFailed) {
            this.props.onStoryOpenFailed(eventPayload.nativeEvent);
        }
    }

    _onStorylyVerticalFeedDismissed = (eventPayload) => {
        if (this.props.onStoryClose) {
            this.props.onStoryClose();
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
            storyGroupSize,
            storyGroupIconHeight,
            storyGroupIconWidth,
            storyGroupIconCornerRadius,
            storyGroupListOrientation,
            storyGroupListSections,
            storyGroupListHorizontalEdgePadding,
            storyGroupListVerticalEdgePadding,
            storyGroupListHorizontalPaddingBetweenItems,
            storyGroupListVerticalPaddingBetweenItems,
            storyGroupTextIsVisible,
            storyGroupTextTypeface,
            storyGroupTextSize,
            storyGroupTextLines,
            storyGroupTextColorSeen,
            storyGroupIconBorderColorSeen,
            storyGroupIconBorderColorNotSeen,
            storyGroupIconBackgroundColor,
            storyGroupPinIconColor,
            storyGroupAnimation,
            storylyLayoutDirection,
            storylyLocale,
            storyItemTextColor,
            storyItemIconBorderColor,
            storyItemProgressBarColor,
            storyItemTextTypeface,
            storyInteractiveTextTypeface,
            storyGroupTextColorNotSeen,
            storyHeaderTextIsVisible,
            storyHeaderIconIsVisible,
            storyHeaderCloseButtonIsVisible,
            storyHeaderCloseIcon,
            storyHeaderShareIcon,
            storyFallbackIsEnabled,
            storyCartIsEnabled,
            storyProductFeed,
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
            'storyGroupStyling': {
                'iconBorderColorSeen': storyGroupIconBorderColorSeen ? storyGroupIconBorderColorSeen.map(processColor) : null,
                'iconBorderColorNotSeen': storyGroupIconBorderColorNotSeen ? storyGroupIconBorderColorNotSeen.map(processColor) : null,
                'iconBackgroundColor': processColor(storyGroupIconBackgroundColor),
                'pinIconColor': processColor(storyGroupPinIconColor),
                'iconHeight': storyGroupIconHeight, 
                'iconWidth': storyGroupIconWidth, 
                'iconCornerRadius': storyGroupIconCornerRadius,
                'iconBorderAnimation': storyGroupAnimation,
                'titleSeenColor': processColor(storyGroupTextColorSeen), 
                'titleNotSeenColor': processColor(storyGroupTextColorNotSeen),
                'titleLineCount': storyGroupTextLines,
                'titleFont': storyGroupTextTypeface, 
                'titleTextSize': storyGroupTextSize,  
                'titleVisible': storyGroupTextIsVisible, 
                'groupSize': storyGroupSize,
            },
            'storyBarStyling': {
                'orientation': storyGroupListOrientation,
                'sections': storyGroupListSections,
                'horizontalEdgePadding': storyGroupListHorizontalEdgePadding,
                'verticalEdgePadding': storyGroupListVerticalEdgePadding,
                'horizontalPaddingBetweenItems': storyGroupListHorizontalPaddingBetweenItems,
                'verticalPaddingBetweenItems': storyGroupListVerticalPaddingBetweenItems,
            },
            'storyStyling': { 
                'headerIconBorderColor': storyItemIconBorderColor ? storyItemIconBorderColor.map(processColor) : null,
                'titleColor': processColor(storyItemTextColor),
                'titleFont': storyItemTextTypeface,
                'interactiveFont': storyInteractiveTextTypeface,
                'progressBarColor': storyItemProgressBarColor ? storyItemProgressBarColor.map(processColor) : null,
                'isTitleVisible': storyHeaderTextIsVisible,
                'isHeaderIconVisible': storyHeaderIconIsVisible,
                'isCloseButtonVisible': storyHeaderCloseButtonIsVisible,
                'closeButtonIcon': storyHeaderCloseIcon,
                'shareButtonIcon': storyHeaderShareIcon,
            },
            'storyShareConfig': {
                'storylyShareUrl': storylyShareUrl,
                'storylyFacebookAppID': storylyFacebookAppID,
            },
            'storyProductConfig': { 
                'isFallbackEnabled': storyFallbackIsEnabled,
                'isCartEnabled': storyCartIsEnabled,
                'productFeed': storyProductFeed,
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

    storyGroupSize: string,
    storyGroupIconBorderColorSeen: arrayOf(string),
    storyGroupIconBorderColorNotSeen: arrayOf(string),
    storyGroupIconBackgroundColor: string,
    storyGroupTextIsVisible: bool,
    storyGroupTextTypeface: string,
    storyGroupTextSize: number,
    storyGroupTextLines: number,
    storyGroupTextColorSeen: string,
    storyGroupTextColorNotSeen: string,
    storyGroupPinIconColor: string,

    storyGroupAnimation: string,
    storyItemIconBorderColor: arrayOf(string),
    storyItemTextColor: string,
    storyItemProgressBarColor: arrayOf(string),
    storyItemTextTypeface: string,
    storyInteractiveTextTypeface: string,
    storyGroupIconHeight: number,
    storyGroupIconWidth: number,
    storyGroupIconCornerRadius: number,
    storyGroupListOrientation: string,
    storyGroupListSections: number,
    storyGroupListHorizontalEdgePadding: number,
    storyGroupListVerticalEdgePadding: number,
    storyGroupListHorizontalPaddingBetweenItems: number,
    storyGroupListVerticalPaddingBetweenItems: number,
    storyHeaderTextIsVisible: bool,
    storyHeaderIconIsVisible: bool,
    storyHeaderCloseButtonIsVisible: bool,
    storyHeaderCloseIcon: string,
    storyHeaderShareIcon: string,
    storylyLayoutDirection: string,
    storyFallbackIsEnabled: bool,
    storyCartIsEnabled: bool,
    storyProductFeed: object,

    onLoad: func,
    onFail: func,
    onPress: func,
    onEvent: func,
    onStoryOpen: func,
    onStoryOpenFailed: func,
    onStoryClose: func,
    onUserInteracted: func,
    onProductHydration: func,
    onCartUpdate: func,
    onProductEvent: func,
}

const STVerticalFeedBar = requireNativeComponent('STVerticalFeedBar', null);
const STVerticalFeedBarGroupView = requireNativeComponent('STVerticalFeedBarGroupView', null);

export default VerticalFeedBar;
