import type { ProcessedColorValue } from "react-native"

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
    storyGroupViewFactory: {
        width: number,
        height: number,
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
        isCartEnabled?: boolean,
    }
    storylyLayoutDirection?: string
}
