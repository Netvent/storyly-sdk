declare module "storyly-react-native" {
  import { Component } from "react";
  import { ViewProps } from "react-native";

  export namespace Storyly {
    export interface Props extends ViewProps {
      storylyId: string;
      customParameter?: string;
      storylyTestMode?: boolean;
      storylySegments?: string[];

      storyGroupPinIconColor?: string;
      storyGroupSize?: "small" | "large" | "custom";

      storyGroupTextSize?: number;
      storyGroupTextLines?: number;
      storyGroupTextColor?: string;
      storyGroupTextIsVisible?: boolean;

      storyGroupIconWidth?: number;
      storyGroupIconHeight?: number;
      storyGroupIconCornerRadius?: number;
      storyGroupIconBackgroundColor?: string;
      storyGroupIconBorderColorSeen?: string[];
      storyGroupIconBorderColorNotSeen?: string[];

      storyGroupListEdgePadding?: number;
      storyGroupListPaddingBetweenItems?: number;

      storyItemTextColor?: string;
      storyItemIconBorderColor?: string[];
      storyItemProgressBarColor?: string[];

      storyHeaderIconIsVisible?: boolean;
      storyHeaderTextIsVisible?: boolean;
      storyHeaderCloseButtonIsVisible?: boolean;

      onLoad?: () => void;
      onFail?: () => void;
      onStoryOpen?: () => void;
      onStoryClose?: () => void;
      onEvent?: (event: StorylyEvent) => void;
      onPress?: (event: StoryPressEvent) => void;
      onUserInteracted?: (event: InteractiveEvent) => void;
    }

    export interface StoryPressEvent {
      nativeEvent: Story;
    }

    export interface StorylyEvent {
      event: string;
      story: Story;
      storyGroup: StoryGroup;
      storyComponent: unknown | null;
    }

    export interface StoryGroup {
      id: number;
      title: string;
      index: number;
      seen: boolean;
      iconUrl: string;
      stories: Story[];
    }

    export interface Story {
      id: number;
      title: string;
      index: number;
      seen: boolean;
      media: {
        url: string;
        type: number;
        actionUrl: string | null;
      };
    }

    export interface InteractiveEvent {
      story: Story;
      storyGroup: StoryGroup;
      storyComponent: {
        type: ReactionType;
        customPayload: string;
      };
    }

    export type ReactionType =
      | "emoji"
      | "rating"
      | "poll"
      | "quiz"
      | "countdown";
  }

  export type ExternalData = Record<string, string>[];

  export class Storyly extends Component<Storyly.Props> {
    open: () => void;
    close: () => void;
    refresh: () => void;
    openStory: (storyUriFromTheDashboard: string) => void;
    setExternalData: (externalData: ExternalData) => void;
    openStoryWithId: (storyGroupId: number, storyId: number) => void;
  }
}
