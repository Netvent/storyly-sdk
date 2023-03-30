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

    open = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.open,
            [],
        );
    };


    close = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.close,
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

    openStoryWithId = (storyGroupId, storyId) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.openStoryWithId,
            [storyGroupId, storyId],
        );
    };

    setExternalData = (externalData) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.setExternalData,
            [externalData],
        ); 
    } 

    hydrateProducts = (products) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.hydrateProducts,
            [products],
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

    _onStorylyStoryPresentFailed = (eventPayload) => {
        if (this.props.onStoryOpenFailed) {
            this.props.onStoryOpenFailed(eventPayload.nativeEvent);
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

    _onStorylyProductEvent = (eventPayload) => {
        if (this.props.onProductEvent) {
            this.props.onProductEvent(eventPayload.nativeEvent);
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
            storylyPayload,
            storylyTestMode,
            storyGroupSize,
            storyGroupIconBorderColorSeen,
            storyGroupIconBorderColorNotSeen,
            storyItemIconBorderColor,
            storyItemProgressBarColor,
            storyItemTextTypeface,
            storyInteractiveTextTypeface,
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
            storyGroupTextColorNotSeen,
            storyHeaderTextIsVisible,
            storyHeaderIconIsVisible,
            storyHeaderCloseButtonIsVisible,
            storyHeaderCloseIcon,
            storyHeaderShareIcon,
            storyGroupViewFactory,
            onLoad,
            onFail,
            onEvent,
            onPress,
            onStoryOpen,
            onStoryOpenFailed,
            onStoryClose,
            onUserInteracted,
            onProductHydration,
            onProductEvent,
            ...otherProps
        } = this.props;
        return (
            <STStoryly
                {...otherProps}
                storylyInit={{ 'storylyId': storylyId, 'storylySegments': storylySegments, 'userProperty': storylyUserProperty, 'customParameter': customParameter, 'storylyPayload': storylyPayload, 'storylyIsTestMode': storylyTestMode }}
                storyGroupSize={storyGroupSize}
                storyGroupIconStyling={{ 'height': storyGroupIconHeight, 'width': storyGroupIconWidth, 'cornerRadius': storyGroupIconCornerRadius }}
                storyGroupListStyling={{
                    'orientation': storyGroupListOrientation,
                    'sections': storyGroupListSections,
                    'horizontalEdgePadding': storyGroupListHorizontalEdgePadding,
                    'verticalEdgePadding': storyGroupListVerticalEdgePadding,
                    'horizontalPaddingBetweenItems': storyGroupListHorizontalPaddingBetweenItems,
                    'verticalPaddingBetweenItems': storyGroupListVerticalPaddingBetweenItems,
                }}
                storyGroupTextStyling={{ 'isVisible': storyGroupTextIsVisible, 'typeface': storyGroupTextTypeface, 'textSize': storyGroupTextSize, 'lines': storyGroupTextLines, 'colorSeen': storyGroupTextColorSeen, 'colorNotSeen': storyGroupTextColorNotSeen }}
                storyHeaderStyling={{ 'isTextVisible': storyHeaderTextIsVisible, 'isIconVisible': storyHeaderIconIsVisible, 'isCloseButtonVisible': storyHeaderCloseButtonIsVisible, 'closeIcon': storyHeaderCloseIcon, 'shareIcon': storyHeaderShareIcon }}
                onStorylyLoaded={this._onStorylyLoaded}
                onStorylyLoadFailed={this._onStorylyLoadFailed}
                onStorylyEvent={this._onStorylyEvent}
                onStorylyActionClicked={this._onStorylyActionClicked}
                onStorylyStoryPresented={onStoryOpen}
                onStorylyStoryPresentFailed={this._onStorylyStoryPresentFailed}
                onStorylyStoryDismissed={onStoryClose}
                onStorylyUserInteracted={this._onStorylyUserInteracted} 
                onStorylyProductHydration={this._onStorylyProductHydration} 
                onStorylyProductEvent={this._onStorylyProductEvent} 
                onCreateCustomView={this._onCreateCustomView}
                onUpdateCustomView={this._onUpdateCustomView}
                storyGroupIconBorderColorSeen={storyGroupIconBorderColorSeen ? storyGroupIconBorderColorSeen.map(processColor) : null}
                storyGroupIconBorderColorNotSeen={storyGroupIconBorderColorNotSeen ? storyGroupIconBorderColorNotSeen.map(processColor) : null}
                storyItemIconBorderColor={storyItemIconBorderColor ? storyItemIconBorderColor.map(processColor) : null}
                storyItemProgressBarColor={storyItemProgressBarColor ? storyItemProgressBarColor.map(processColor) : null}
                storyItemTextTypeface={storyItemTextTypeface}
                storyInteractiveTextTypeface={storyInteractiveTextTypeface}
                storyGroupViewFactory={storyGroupViewFactory ? { width: storyGroupViewFactory.width, height: storyGroupViewFactory.height } : null}
                ref={el => (this._storylyView = el)}>
                {storyGroupViewFactory ?
                    <STStorylyGroupViewFactory
                        ref={(ref) => { this.customViewFactoryRef = ref }}
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
    storylyShareUrl: string,
    customParameter: string,
    storylyTestMode: bool,
    storylyPayload: string,

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
 
    onLoad: func,
    onFail: func,
    onPress: func,
    onEvent: func,
    onStoryOpen: func,
    onStoryOpenFailed: func,
    onStoryClose: func,
    onUserInteracted: func,
    onProductHydration: func,
    onProductEvent: func
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
                <STStorylyGroupView key={current.length} style={{ width: width, height: height }}>
                    <CustomizedView storyGroup={null} />
                </STStorylyGroupView>
            )
        ]))
    }

    const onUpdateCustomView = ({ index, storyGroup }) => {
        let updated = customViewList.map((value, i) => {
            if (i === index) {
                return (
                    <STStorylyGroupView key={index} style={{ width: width, height: height }}>
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
