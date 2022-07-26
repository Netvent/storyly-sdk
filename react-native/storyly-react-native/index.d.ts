declare module "storyly-react-native" {
  import { Component } from "react";
  import { ViewProps } from "react-native";

  export namespace Storyly {
    export interface Props extends ViewProps {
      storylyId: string;
      customParameter?: string;
      storylyTestMode?: boolean;
      storylySegments?: string[];
      storylyUserProperty?: Record<string, string>[];

      storyGroupSize?: "small" | "large" | "custom";
      storyGroupIconWidth?: number;
      storyGroupIconHeight?: number;
      storyGroupIconCornerRadius?: number;
      storyGroupIconBackgroundColor?: string;
      storyGroupIconBorderColorSeen?: string[];
      storyGroupIconBorderColorNotSeen?: string[];

      storyGroupTextSize?: number;
      storyGroupTextLines?: number;
      storyGroupTextColorSeen?: string;
      storyGroupTextColorUnseen?: string;
      storyGroupTextIsVisible?: boolean;
      storyGroupPinIconColor?: string;

      storyGroupListEdgePadding?: number;
      storyGroupListPaddingBetweenItems?: number;

      storyItemTextColor?: string;
      storyItemIconBorderColor?: string[];
      storyItemProgressBarColor?: string[];

      storyHeaderIconIsVisible?: boolean;
      storyHeaderTextIsVisible?: boolean;
      storyHeaderCloseButtonIsVisible?: boolean;

      onLoad?: (event: StoryLoadEvent) => void;
      onFail?: (event: String) => void;
      onStoryOpen?: () => void;
      onStoryClose?: () => void;
      onEvent?: (event: StoryEvent) => void;
      onPress?: (event: StoryPressEvent) => void;
      onUserInteracted?: (event: StoryInteractiveEvent) => void;
    }

    export interface StoryLoadEvent {
      storyGroupList: StoryGroup[];
      dataSource: string;
    }

    export interface StoryFailEvent {
      errorMessage: string;
    }

    export interface StoryPressEvent {
      story: Story;
    }

    export interface StoryEvent {
      event: string;
      story: Story;
      storyGroup: StoryGroup;
      storyComponent: unknown | null;
    }

    export interface StoryInteractiveEvent {
      story: Story;
      storyGroup: StoryGroup;
      storyComponent: {
        type: ReactionType;
        customPayload: string;
      };
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

    export type ReactionType =
      | "emoji"
      | "rating"
      | "poll"
      | "quiz"
      | "countdown"
      | "promocode";
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
