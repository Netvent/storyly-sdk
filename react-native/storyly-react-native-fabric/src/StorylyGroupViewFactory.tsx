import { forwardRef, useState, useImperativeHandle } from "react";
import { type ViewProps } from 'react-native';
import type { UpdateCustomViewEvent } from "./data/event";
import React from "react";
import type { StoryGroupViewFactory } from "./data/story";
import StorylyGroupView from "./fabric/StorylyGroupViewNativeComponent"

export type StorylyGroupViewFactoryHandle = {
    onCreateCustomView: () => void;
    onUpdateCustomView: (updateProps: UpdateCustomViewEvent) => void;
}

interface StorylyGroupViewFactoryProps extends ViewProps, StoryGroupViewFactory {}

export const STStorylyGroupViewFactory = forwardRef<StorylyGroupViewFactoryHandle, StorylyGroupViewFactoryProps>((props, ref) => {
    const [customViewList, setCustomViewList] = useState<React.JSX.Element[]>([])

    useImperativeHandle(ref, () => ({
        onCreateCustomView, onUpdateCustomView
    }))

    const onCreateCustomView = () => {
        setCustomViewList((current) => ([
            ...current, (
                <StorylyGroupView key={current.length} style={{ width: props.width, height: props.height }}>
                    <props.customView storyGroup={undefined} />
                </StorylyGroupView>
            )
        ]))
    }

    const onUpdateCustomView = ({index, storyGroup}: UpdateCustomViewEvent) => {
        let updated = customViewList.map((value, i) => {
            if (i === index) {
                return (
                    <StorylyGroupView key={index} style={{ width: props.width, height: props.height }}>
                        <props.customView  storyGroup={storyGroup} />
                    </StorylyGroupView>
                )
            }
            return value
        })
        setCustomViewList([...updated])
    }

    return (<>{customViewList}</>)
})