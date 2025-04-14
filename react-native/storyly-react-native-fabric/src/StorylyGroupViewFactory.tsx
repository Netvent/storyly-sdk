import { forwardRef, useState, useImperativeHandle } from "react";
import { type ViewProps } from 'react-native';
import type { UpdateCustomViewEvent } from "./data/event";
import React from "react";
import type { StoryGroup } from "./data/story";
import StorylyGroupView from "./fabric/StorylyGroupViewNativeComponent"


export interface StoryGroupViewFactory {
    width: number;
    height: number;
    customView: React.FC<{storyGroup?: StoryGroup}>;
}

export type StorylyGroupViewFactoryHandle = {
    onCreateCustomView: () => void;
    onUpdateCustomView: (updateProps: UpdateCustomViewEvent) => void;
}

interface StorylyGroupViewFactoryProps extends ViewProps, StoryGroupViewFactory {}

export const STStorylyGroupViewFactory = forwardRef<StorylyGroupViewFactoryHandle, StorylyGroupViewFactoryProps>((props, ref) => {
    const [customViewList, setCustomViewList] = useState<(Optional<StoryGroup>)[]>([])

    useImperativeHandle(ref, () => ({
        onCreateCustomView, onUpdateCustomView
    }))

    const onCreateCustomView = () => {
        console.log("STR:RN:onCreateCustomView")
        setCustomViewList((current) => ([...current, null]))
    }

    const onUpdateCustomView = ({index, storyGroup}: UpdateCustomViewEvent) => {
        console.log(`STR:RN:onUpdateCustomView:${index}:${storyGroup?.id}`);
        setCustomViewList((current) => (
            [...current.map((value, i) => ((i === index) ? storyGroup : value))]
        ))
    }

    const WrappedView = ({ storyGroup }: { storyGroup?: StoryGroup }) => {
        return (
            <props.customView storyGroup={storyGroup} />
        )
    }

    return (
        <>
            {customViewList.map((storyGroup, index) => (
                <StorylyGroupView key={index} style={{ width: props.width, height: props.height, position: 'absolute' }}>
                    <WrappedView storyGroup={storyGroup == null ? undefined : storyGroup} />
                </StorylyGroupView>
            ))}
        </>
    )
})
