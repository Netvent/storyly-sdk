declare module "storyly-react-native" {
  import { Component } from "react";
  import { ViewProps } from "react-native";

  export namespace Storyly {
    export interface Props extends ViewProps {
      storylyId: string;
      customParameter?: string;
      storylyTestMode?: boolean;
      storylySegments?: string[];
      storylyUserProperty?: Record<string, string>;
      storylyPayload?: string;
      storylyShareUrl?: string;

      storyGroupSize?: "small" | "large" | "custom";
      storyGroupAnimation?: "border-rotation" | "disabled";
      storyGroupIconWidth?: number;
      storyGroupIconHeight?: number;
      storyGroupIconCornerRadius?: number;
      storyGroupIconBackgroundColor?: string;
      storyGroupIconBorderColorSeen?: string[];
      storyGroupIconBorderColorNotSeen?: string[];
      storyGroupViewFactory?: StoryGroupViewFactory,

      storyGroupTextSize?: number;
      storyGroupTextLines?: number;
      storyGroupTextColorSeen?: string;
      storyGroupTextColorNotSeen?: string;
      storyGroupTextIsVisible?: boolean;
      storyGroupTextTypeface?: string;
      storyGroupPinIconColor?: string;

      storyGroupListOrientation?: "horizontal" | "vertical";
      storyGroupListSections?: number;
      storyGroupListHorizontalEdgePadding?: number;
      storyGroupListVerticalEdgePadding?: number;
      storyGroupListHorizontalPaddingBetweenItems?: number;
      storyGroupListVerticalPaddingBetweenItems?: number;

      storyItemTextColor?: string;
      storyItemIconBorderColor?: string[];
      storyItemProgressBarColor?: string[];
      storyItemTextTypeface?: string;
      storyInteractiveTextTypeface?: string;

      storyHeaderIconIsVisible?: boolean;
      storyHeaderTextIsVisible?: boolean;
      storyHeaderCloseButtonIsVisible?: boolean;
      storyHeaderCloseIcon?: string,
      storyHeaderShareIcon?: string,


      storylyLayoutDirection?: "ltr" | "rtl";

      onLoad?: (event: StoryLoadEvent) => void;
      onFail?: (event: String) => void;
      onStoryOpen?: () => void;
      onStoryClose?: () => void;
      onEvent?: (event: StoryEvent) => void;
      onPress?: (event: StoryPressEvent) => void;
      onUserInteracted?: (event: StoryInteractiveEvent) => void;
      onProductHydration?: (event: StoryProductHydrationEvent) => void;
      onProductEvent?: (event: StoryProductEvent) => void;
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
      story?: Story;
      storyGroup?: StoryGroup;
      storyComponent?: StoryComponent;
    }

    export interface StoryProductEvent {
      event: string;
      product: STRProductItem;
      extras: Map<String,String>;
    }

    export interface StoryProductHydrationEvent {
      productIds: string[];
    }

    export interface StoryHydrationEvent {
      event: string;
      story?: Story;
      storyGroup?: StoryGroup;
      storyComponent?: StoryComponent;
    }

    export interface StoryComponent {
      id: string;
      type: ReactionType;
    }

    export interface StoryQuizComponent extends StoryComponent {
      title: string;
      options: string[];
      rightAnswerIndex?: number;
      selectedOptionIndex: number;
      customPayload?: string;
    }

    export interface StoryPollComponent extends StoryComponent {
      title: string;
      emojiCodes: string[];
      selectedEmojiIndex: number;
      customPayload?: string;
    }

    export interface StoryRatingComponent extends StoryComponent {
      title: string;
      emojiCodes: string[];
      selectedEmojiIndex: number;
      customPayload?: string;
    }

    export interface StoryPromoCodeComponent extends StoryComponent {
      text: string;
    }

    export interface StoryCommentComponent extends StoryComponent {
      text: string;
    }

    export interface StoryInteractiveEvent {
      story: Story;
      storyGroup: StoryGroup;
      storyComponent: StoryComponent;
    }

    export interface MomentsUser {
      id?: string;
      avatarUrl?: string;
      username?: string;
    }

    export interface StoryGroup {
      id: string;
      title: string;
      iconUrl?: string;
      thematicIconUrls?: Record<string, string>
      coverUrl?: string;
      index: number;
      seen: boolean;
      stories: Story[];
      type: string,
      momentsUser?: MomentsUser
    }

    export interface Story {
      id: string;
      title: string;
      name: string;
      index: number;
      pinned: boolean;
      seen: boolean;
      currentTime: number;
      media: {
        type: number;
        storyComponentList?: StoryComponent[];
        actionUrl?: string;
        actionUrlList?: string[];
        previewUrl?: string;
      };
    }

    export type ReactionType =
      | "emoji"
      | "rating"
      | "poll"
      | "quiz"
      | "countdown"
      | "promocode"
      | "swipeaction"
      | "buttonaction"
      | "text"
      | "image"
      | "producttag"
      | "productcard"
      | "comment"
      | "video"
      | "vod";
  }

  export type ExternalData = Record<string, string>[];

  export interface StoryGroupViewFactory {
    width: number;
    height: number;
    customView: ({ storyGroup: StoryGroup }) => JSX.Element;
  }

  export class Storyly extends Component<Storyly.Props> {
    open: () => void;
    close: () => void;
    refresh: () => void;
    openStory: (storyUriFromTheDashboard: string) => void;
    setExternalData: (externalData: ExternalData) => void;
    openStoryWithId: (storyGroupId: string, storyId: string) => void;
    hydrateProducts: (products: STRProductItem[]) => void;
  }

  export interface STRProductItem {
    productId: string;
    productGroupId: string;
    title: string;
    desc: String;
    price: number;
    salesPrice?: number;
    currency: String;
    imageUrls?: String[];
    variants: STRProductVariant[];
  } 

  export interface STRProductVariant {
    name: string;
    value: string;
  }
}
