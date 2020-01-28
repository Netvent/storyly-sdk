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

    render() {
        const {
            storyGroupIconBorderColorSeen,
            storyGroupIconBorderColorNotSeen,
            storyItemIconBorderColor,
            storyItemProgressBarColor,
            onLoad,
            onFail,
            onPress
            ...otherProps
        } = this.props;
        return (
            <STStoryly
                {...otherProps}
                onStorylyLoaded={onLoad}
                onStorylyLoadFailed={onFail}
                onStorylyActionClicked={onPress}
                storyGroupIconBorderColorSeen={storyGroupIconBorderColorSeen ? storyGroupIconBorderColorSeen.map(processColor) : null}
                storyGroupIconBorderColorNotSeen={storyGroupIconBorderColorNotSeen ? storyGroupIconBorderColorNotSeen.map(processColor) : null}
                storyItemIconBorderColor={storyItemIconBorderColor ? storyItemIconBorderColor.map(processColor) : null}
                storyItemProgressBarColor={storyItemProgressBarColor ? storyItemProgressBarColor.map(processColor) : null}
                ref={el => (this._storylyView = el)}/>
        )
    }
}

Storyly.propTypes = {
    ...ViewPropTypes,
    storylyId: string.isRequired,

    storyGroupIconBorderColorSeen: arrayOf(string),
    storyGroupIconBorderColorNotSeen: arrayOf(string),
    storyGroupIconBackgroundColor: string,
    storyGroupTextColor: string,
    storyGroupPinIconColor: string,
    storyItemIconBorderColor: arrayOf(string),
    storyItemTextColor: string,
    storyItemProgressBarColor: arrayOf(string),

    onLoad: func,
    onFail: func,
    onPress: func
}

const STStoryly = requireNativeComponent('STStoryly', null);

export default Storyly;
