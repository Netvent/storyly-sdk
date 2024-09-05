import React, { Component, useState, forwardRef, useImperativeHandle } from 'react';
import {
    requireNativeComponent,
    UIManager,
    findNodeHandle,
    processColor,
} from 'react-native';
import { string, arrayOf, func, number, bool, object } from 'prop-types';

class Storyly extends Component {
    refresh = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.refresh,
            [],
        );
    };

    resumeStory = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.resumeStory,
            [],
        );
    };

    pauseStory = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.pauseStory,
            [],
        );
    };

    closeStory = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.closeStory,
            [],
        );
    };

    openStory = (payload) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.openStory,
            [payload],
        );
    };

    openStoryWithId = (storyGroupId, storyId, playMode) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.openStoryWithId,
            [storyGroupId, storyId, playMode],
        );
    };

    hydrateProducts = (products) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.hydrateProducts,
            [products],
        );
    }

    updateCart = (cart) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.updateCart,
            [cart],
        );
    }

    approveCartChange = (responseId, cart) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.approveCartChange,
            [responseId, cart],
        );
    }

    rejectCartChange = (responseId, failMessage) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.rejectCartChange,
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

    _onStorylyStoryPresented = (eventPayload) => {
        if (this.props.onStoryOpen) {
            this.props.onStoryOpen();
        }
    }

    _onStorylyStoryPresentFailed = (eventPayload) => {
        if (this.props.onStoryOpenFailed) {
            this.props.onStoryOpenFailed(eventPayload.nativeEvent);
        }
    }

    _onStorylyStoryDismissed = (eventPayload) => {
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

    _onStorylySizeChanged = (eventPayload) => {
        if (this.props.onSizeChanged) {
            this.props.onSizeChanged(eventPayload.nativeEvent);
        }
    }

    _onCreateCustomView = (_) => {
        this.customViewFactoryRef?.onCreateCustomView()
    }

    _onUpdateCustomView = (eventPayload) => {
        this.customViewFactoryRef?.onUpdateCustomView(eventPayload.nativeEvent)
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
            storyGroupViewFactory,
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
            'storyGroupViewFactory': {
                'width': storyGroupViewFactory ? storyGroupViewFactory.width : 0,
                'height': storyGroupViewFactory ? storyGroupViewFactory.height : 0,
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
            <STStoryly
                {...otherProps}
                onStorylyLoaded={this._onStorylyLoaded}
                onStorylyLoadFailed={this._onStorylyLoadFailed}
                onStorylyEvent={this._onStorylyEvent}
                onStorylyActionClicked={this._onStorylyActionClicked}
                onStorylyStoryPresented={this._onStorylyStoryPresented}
                onStorylyStoryPresentFailed={this._onStorylyStoryPresentFailed}
                onStorylyStoryDismissed={this._onStorylyStoryDismissed}
                onStorylyUserInteracted={this._onStorylyUserInteracted}
                onStorylyProductHydration={this._onStorylyProductHydration} 
                onStorylyCartUpdated={this._onStorylyCartUpdated} 
                onStorylyProductEvent={this._onStorylyProductEvent}
                onStorylySizeChanged={this._onStorylySizeChanged}
                onCreateCustomView={this._onCreateCustomView}
                onUpdateCustomView={this._onUpdateCustomView}
                storyly={ storylyConfig }
                ref={el => (this._storylyView = el)}>
                {storyGroupViewFactory ?
                    <STStorylyGroupViewFactory
                        ref={(ref) => { this.customViewFactoryRef = ref }}
                        key={JSON.stringify(storylyConfig)}
                        width={storyGroupViewFactory.width}
                        height={storyGroupViewFactory.height}
                        CustomizedView={storyGroupViewFactory.customView} /> : <></>}
            </STStoryly>
        )
    }
}

Storyly.propTypes = {
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
    storyGroupViewFactory: object,
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

const STStoryly = requireNativeComponent('STStoryly', null);

const STStorylyGroupViewFactory = forwardRef(({ width, height, CustomizedView }, ref) => {
    const [customViewList, setCustomViewList] = useState([])

    useImperativeHandle(ref, () => ({
        onCreateCustomView, onUpdateCustomView
    }))

    const onCreateCustomView = (_) => {
        setCustomViewList((current) => ([
            ...current, (
                <STStorylyGroupView key={current.length} style={{ width: width, height: height, position: 'absolute' }}>
                    <CustomizedView storyGroup={null} />
                </STStorylyGroupView>
            )
        ]))
    }

    const onUpdateCustomView = ({ index, storyGroup }) => {
        let updated = customViewList.map((value, i) => {
            if (i === index) {
                return (
                    <STStorylyGroupView key={index} style={{ width: width, height: height, position: 'absolute' }}>
                        <CustomizedView storyGroup={storyGroup} />
                    </STStorylyGroupView>
                )
            }
            return value
        })
        setCustomViewList([...updated])
    }

    return (<>{customViewList}</>)
})

const STStorylyGroupView = requireNativeComponent('STStorylyGroupView', null);

export default Storyly;
