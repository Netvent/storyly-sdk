import { processColor, type ProcessedColorValue } from "react-native"
import type { StorylyProps } from "storyly-react-native"

export interface StorylyConfig {
    storylyInit: {
        storylyId: string,
        storylySegments?: string[],
        userProperty?: Record<string, string>,
        customParameter?: string,
        storylyIsTestMode?: boolean,
        storylyPayload?: string,
    }
    storyGroupStyling: {
        iconBorderColorSeen?: Optional<ProcessedColorValue>[],
        iconBorderColorNotSeen?: Optional<ProcessedColorValue>[],
        iconBackgroundColor?: ProcessedColorValue,
        pinIconColor?: ProcessedColorValue,
        iconHeight?: number,
        iconWidth?: number,
        iconCornerRadius?: number,
        iconBorderAnimation?: string,
        titleSeenColor?: ProcessedColorValue,
        titleNotSeenColor?: ProcessedColorValue,
        titleLineCount?: number,
        titleFont?: string,
        titleTextSize?: number,
        titleVisible?: boolean,
        groupSize?: string,
    }
    storyBarStyling: {
        orientation?: string,
        sections?: number,
        horizontalEdgePadding?: number,
        verticalEdgePadding?: number,
        horizontalPaddingBetweenItems?: number,
        verticalPaddingBetweenItems?: number,
    }
    storyStyling: {
        headerIconBorderColor?: Optional<ProcessedColorValue>[],
        titleColor?: ProcessedColorValue,
        titleFont?: string,
        interactiveFont?: string,
        progressBarColor?: Optional<ProcessedColorValue>[],
        isTitleVisible?: boolean,
        isHeaderIconVisible?: boolean,
        isCloseButtonVisible?: boolean,
        closeButtonIcon?: string,
        shareButtonIcon?: string,
    }
    storyShareConfig: {
        storylyShareUrl?: string,
        storylyFacebookAppID?: string,
    }
    storyProductConfig: {
        isFallbackEnabled?: boolean,
        isCartEnabled?: boolean
    }
    storylyLayoutDirection?: string
    storylyLocale?: string
}

export const mapStorylyConfig = (props: StorylyProps) => {
    return JSON.stringify({
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
            'isCartEnabled': props.storyCartIsEnabled
        },
        'storylyLayoutDirection': props.storylyLayoutDirection,
        'storylyLocale': props.storylyLocale,

    })
}
