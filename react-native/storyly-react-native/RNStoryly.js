import React, { Component } from 'react';
import { requireNativeComponent,
    UIManager,
    findNodeHandle,
    ViewPropTypes,
    processColor} from 'react-native';
import { string, arrayOf, func } from 'prop-types';

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

    setExternalData = (externalData) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this._storylyView),
            UIManager.getViewManagerConfig('STStoryly').Commands.setExternalData,
            [externalData],
        );
    }

    render() {
        const {
            storylyId,
            storylySegments,
            customParameter,
            storyGroupIconBorderColorSeen,
            storyGroupIconBorderColorNotSeen,
            storyGroupIconForegroundColors,
            storyItemIconBorderColor,
            storyItemProgressBarColor,
            onLoad,
            onFail,
            onPress,
            onStoryOpen,
            onStoryClose,
            ...otherProps
        } = this.props;
        return (
            <STStoryly
                {...otherProps}
                storylyInit={{'storylyId': storylyId, 'storylySegments': storylySegments, 'customParameter': customParameter}}
                onStorylyLoaded={onLoad}
                onStorylyLoadFailed={onFail}
                onStorylyActionClicked={onPress}
                onStorylyStoryPresented={onStoryOpen}
                onStorylyStoryDismissed={onStoryClose}
                storyGroupIconBorderColorSeen={storyGroupIconBorderColorSeen ? storyGroupIconBorderColorSeen.map(processColor) : null}
                storyGroupIconBorderColorNotSeen={storyGroupIconBorderColorNotSeen ? storyGroupIconBorderColorNotSeen.map(processColor) : null}
                storyGroupIconForegroundColors={storyGroupIconForegroundColors ? storyGroupIconForegroundColors.map(processColor) : null}
                storyItemIconBorderColor={storyItemIconBorderColor ? storyItemIconBorderColor.map(processColor) : null}
                storyItemProgressBarColor={storyItemProgressBarColor ? storyItemProgressBarColor.map(processColor) : null}
                ref={el => (this._storylyView = el)}/>
        )
    }
}

Storyly.propTypes = {
    ...ViewPropTypes,
    storylyId: string.isRequired,
    storylySegments: arrayOf(string),
    customParameter: string,

    storyGroupIconBorderColorSeen: arrayOf(string),
    storyGroupIconBorderColorNotSeen: arrayOf(string),
    storyGroupIconBackgroundColor: string,
    storyGroupTextColor: string,
    storyGroupPinIconColor: string,
    storyGroupIconForegroundColors: arrayOf(string),
    storyGroupSize: string,
    storyItemIconBorderColor: arrayOf(string),
    storyItemTextColor: string,
    storyItemProgressBarColor: arrayOf(string),

    onLoad: func,
    onFail: func,
    onPress: func,
    onStoryOpen: func,
    onStoryClose: func
}

const STStoryly = requireNativeComponent('STStoryly', null);

export default Storyly;
