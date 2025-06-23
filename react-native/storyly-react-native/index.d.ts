declare module "storyly-react-native" {
  import { Component, JSX } from "react";
  import { ViewProps } from "react-native";

  export namespace Storyly {
    export interface Props extends ViewProps {
      storylyId: string;
      customParameter?: string;
      storylyTestMode?: boolean;
      storylySegments?: string[];
      storylyUserProperty?: Record<string, string>;
      storylyShareUrl?: string;
      storylyFacebookAppID?: string;

      storyGroupSize?: "small" | "large" | "custom";
      storyGroupAnimation?: "border-rotation" | "disabled";
      storyGroupIconWidth?: number;
      storyGroupIconHeight?: number;
      storyGroupCustomIconSizeList?: StoryGroupCustomIconSize[];
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
      storyGroupPinIconVisible?: boolean;
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
      storyHeaderCloseIcon?: string;
      storyHeaderShareIcon?: string;

      storyFallbackIsEnabled?: boolean;
      storyCartIsEnabled?: boolean;
      storyProductFeed?: Record<string, STRProductItem[]>;

      storylyLayoutDirection?: "ltr" | "rtl";
      storylyLocale?: string;

      onLoad?: (event: StoryLoadEvent) => void;
      onFail?: (event: StoryFailEvent) => void;
      onStoryOpen?: () => void;
      onStoryOpenFailed?: (event: StoryOpenFailedEvent) => void;
      onStoryClose?: () => void;
      onEvent?: (event: StoryEvent) => void;
      onPress?: (event: StoryPressEvent) => void;
      onUserInteracted?: (event: StoryInteractiveEvent) => void;
      onProductHydration?: (event: StoryProductHydrationEvent) => void;
      onCartUpdate?: (event: StoryProductCartUpdateEvent) => void;
      onWishlistUpdate?: (event: StoryWishlistUpdateEvent) => void;
      onProductEvent?: (event: ProductEvent) => void;
      onSizeChanged?: (event: SizeChangedEvent) => void;
    }

    export interface StoryLoadEvent {
      storyGroupList: StoryGroup[];
      dataSource: string;
    }

    export interface StoryFailEvent {
      errorMessage: string;
    }

    export interface StoryOpenFailedEvent {
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

    export interface StoryProductHydrationEvent {
      products: STRProductInformation[];
    }

    export interface StoryProductCartUpdateEvent {
      event: string;
      cart: STRCart;
      change: STRCartItem;
      responseId: string;
    }

    export interface StoryWishlistUpdateEvent {
      event: string;
      item: STRProductItem;
      responseId: string;
    }

    export interface ProductEvent {
      event: string;
    }

    export interface StoryHydrationEvent {
      event: string;
      story?: Story;
      storyGroup?: StoryGroup;
      storyComponent?: StoryComponent;
    }

    export interface SizeChangedEvent {
      width: number;
      height: number;
    }

    export interface StoryComponent {
      id: string;
      type: ReactionType;
      customPayload?: string;
    }

    export interface StorySwipeComponent extends StoryComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface StoryButtonComponent extends StoryComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface StoryProductTagComponent extends StoryComponent {
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface StoryProductCardComponent extends StoryComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface StoryProductCatalogComponent extends StoryComponent {
      text: string;
      actionUrlList?: string[];
      products?: STRProductItem[];
    }

    export interface StoryQuizComponent extends StoryComponent {
      title: string;
      options: string[];
      rightAnswerIndex?: number;
      selectedOptionIndex: number;
    }

    export interface StoryImageQuizComponent extends StoryComponent {
      title: string;
      options: string[];
      rightAnswerIndex?: number;
      selectedOptionIndex: number;
    }

    export interface StoryPollComponent extends StoryComponent {
      title: string;
      emojiCodes: string[];
      selectedEmojiIndex: number;
    }

    export interface StoryRatingComponent extends StoryComponent {
      title: string;
      emojiCodes: string[];
      selectedEmojiIndex: number;
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

    export interface StoryGroup {
      id: string;
      title: string;
      iconUrl?: string;
      index: number;
      pinned: boolean;
      seen: boolean;
      stories: Story[];
      type: string,
      name: string,
      nudge: boolean,
      style?: StoryGroupStyle,
    }

    export interface Story {
      id: string;
      index: number;
      title: string;
      name: string;
      seen: boolean;
      currentTime: number;
      actionUrl: string;
      previewUrl: string;
      storyComponentList?: StoryComponent[];
      actionProducts?: STRProductItem[];
    }

    export interface Media {
      type: number;
      storyComponentList?: StoryComponent[];
      actionUrl?: string;
      previewUrl?: string;
      actionUrlList?: string[];
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

    export type StoryGroupCustomIconSizeType =
      | "pinned";
  
    export interface StoryGroupCustomIconSize {
      type: StoryGroupCustomIconSizeType;
      size: number;
    }
  }

  export interface StoryGroupStyle {
    borderUnseenColors?: [string],
    textUnseenColor?: string,
    badge?: StoryGroupBadgeStyle,
  }

  export interface StoryGroupBadgeStyle {
    backgroundColor?: string,
    textColor?: string,
    endTime?: number,
    template?: string,
    text?: string,
  }


  export interface StoryGroupViewFactory {
    width: number;
    height: number;
    customView: ({ storyGroup: StoryGroup }) => JSX.Element;
  }

  export class Storyly extends Component<Storyly.Props> {
    refresh: () => void;
    pauseStory: () => void;
    resumeStory: () => void;
    closeStory: () => void;
    openStory: (storyUriFromTheDashboard: string) => void;
    openStoryWithId: (storyGroupId: string, storyId?: string, playMode?: String) => void;
    hydrateProducts: (products: STRProductItem[]) => void;
    hydrateWishlist: (products: STRProductItem[]) => void;
    updateCart: (cart: STRCart) => void;
    approveCartChange: (responseId: string, cart: STRCart) => void;
    rejectCartChange: (responseId: string, failMessage: string) => void;
    approveWishlistChange: (responseId: string, item: STRProductItem) => void;
    rejectWishlistChange: (responseId: string, failMessage: string) => void;
  }

  export interface STRProductItem {
    productId: string;
    productGroupId: string;
    title: string;
    desc: string;
    price: number;
    salesPrice?: number;
    currency: string;
    imageUrls?: string[];
    url?: string;
    variants: STRProductVariant[];
    ctaText?: string;
    wishlist?: boolean;
  }

  export interface STRProductVariant {
    name: string;
    value: string;
    key: string;
  }

  export interface STRCart {
    items: STRCartItem[];
    totalPrice: number;
    oldTotalPrice?: number;
    currency: string;
  }

  export interface STRCartItem {
    item: STRProductItem;
    totalPrice?: number;
    oldTotalPrice?: number;
    quantity: number;
  }

  export interface STRProductInformation {
    productId?: string;
    productGroupId?: string;
  }

  export namespace VerticalFeedBar {
    export interface Props extends ViewProps {
      storylyId: string;
      customParameter?: string;
      storylyTestMode?: boolean;
      storylySegments?: string[];
      storylyUserProperty?: Record<string, string>;
      storylyLayoutDirection?: "ltr" | "rtl";
      storylyLocale?: string;
      storylyMaxItemCount?: number;

      //ShareConfig
      storylyShareUrl?: string;
      storylyFacebookAppID?: string;

      //BarStyling
      verticalFeedGroupListSections?: number;
      verticalFeedGroupListHorizontalEdgePadding?: number;
      verticalFeedGroupListVerticalEdgePadding?: number;
      verticalFeedGroupListHorizontalPaddingBetweenItems?: number;
      verticalFeedGroupListVerticalPaddingBetweenItems?: number;

      //GroupStyling
      verticalFeedGroupIconHeight?: number;
      verticalFeedGroupIconCornerRadius?: number;
      verticalFeedGroupIconBackgroundColor?: string;
      verticalFeedGroupTextSize?: number;
      verticalFeedGroupTextIsVisible?: boolean;
      verticalFeedGroupTextTypeface?: string;
      verticalFeedGroupTextColor?: string;
      verticalFeedTypeIndicatorIsVisible?: boolean;
      verticalFeedGroupOrder?: "static" |"bySeenState" ;
      verticalFeedGroupMinLikeCountToShowIcon?: number;
      verticalFeedGroupMinImpressionCountToShowIcon?: number;
      verticalFeedGroupImpressionIcon?: string;
      verticalFeedGroupLikeIcon?: string;

      //VerticalFeedCustomization
      verticalFeedItemTextTypeface?: string;
      verticalFeedItemInteractiveTextTypeface?: string;
      verticalFeedItemProgressBarColor?: string[];
      verticalFeedItemTitleVisibility?: boolean;
      verticalFeedItemProgressBarVisibility?: boolean;
      verticalFeedItemCloseButtonIsVisible?: boolean;
      verticalFeedItemLikeButtonIsVisible?: boolean;
      verticalFeedItemShareButtonIsVisible?: boolean;
      verticalFeedItemCloseIcon?: string;
      verticalFeedItemShareIcon?: string;
      verticalFeedItemLikeIcon?: string;

      //ProductConfig
      verticalFeedFallbackIsEnabled?: boolean;
      verticalFeedCartIsEnabled?: boolean;
      verticalFeedProductFeed?: Record<string, STRProductItem[]>;

      onLoad?: (event: VerticalFeedLoadEvent) => void;
      onFail?: (event: string) => void;
      onVerticalFeedOpen?: () => void;
      onVerticalFeedClose?: () => void;
      onEvent?: (event: VerticalFeedEvent) => void;
      onPress?: (event: VerticalFeedPressEvent) => void;
      onUserInteracted?: (event: VerticalFeedItemInteractiveEvent) => void;
      onProductHydration?: (event: VerticalFeedProductHydrationEvent) => void;
      onCartUpdate?: (event: VerticalFeedProductCartUpdateEvent) => void;
      onWishlistUpdate?: (event: VerticalFeedWishlistUpdateEvent) => void;
      onProductEvent?: (event: ProductEvent) => void;
    }

    export interface VerticalFeedLoadEvent {
      feedGroupList: VerticalFeedGroup[];
      dataSource: string;
    }

    export interface VerticalFeedFailEvent {
      errorMessage: string;
    }

    export interface VerticalFeedPressEvent {
      feedItem: VerticalFeedItem;
    }

    export interface VerticalFeedEvent {
      event: string;
      feedItem?: VerticalFeedItem;
      feedGroup?: VerticalFeedGroup;
      feedItemComponent?: VerticalFeedItemComponent;
    }

    export interface VerticalFeedProductHydrationEvent {
      products: STRProductInformation[];
    }

    export interface VerticalFeedProductCartUpdateEvent {
      event: string;
      cart: STRCart;
      change: STRCartItem;
      responseId: string;
    }

    export interface VerticalFeedWishlistUpdateEvent {
      event: string;
      item: STRProductItem;
      responseId: string;
    }

    export interface ProductEvent {
      event: string;
    }

    export interface VerticalFeedHydrationEvent {
      event: string;
      feedItem?: VerticalFeedItem;
      feedGroup?: VerticalFeedGroup;
      feedItemComponent?: VerticalFeedItemComponent;
    }

    export interface VerticalFeedItemComponent {
      id: string;
      type: ReactionType;
      customPayload?: string;
    }

    export interface VerticalFeedItemSwipeComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemButtonComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemProductTagComponent extends VerticalFeedItemComponent {
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemProductCardComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemProductCatalogComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrlList?: string[];
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemQuizComponent extends VerticalFeedItemComponent {
      title: string;
      options: string[];
      rightAnswerIndex?: number;
      selectedOptionIndex: number;
      customPayload?: string;
    }

    export interface VerticalFeedItemImageQuizComponent extends VerticalFeedItemComponent {
      title: string;
      options: string[];
      rightAnswerIndex?: number;
      selectedOptionIndex: number;
    }

    export interface VerticalFeedItemPollComponent extends VerticalFeedItemComponent {
      title: string;
      emojiCodes: string[];
      selectedEmojiIndex: number;
      customPayload?: string;
    }

    export interface VerticalFeedItemRatingComponent extends VerticalFeedItemComponent {
      title: string;
      emojiCodes: string[];
      selectedEmojiIndex: number;
      customPayload?: string;
    }

    export interface VerticalFeedItemPromoCodeComponent extends VerticalFeedItemComponent {
      text: string;
    }

    export interface VerticalFeedItemCommentComponent extends VerticalFeedItemComponent {
      text: string;
    }

    export interface VerticalFeedItemInteractiveEvent {
      story: VerticalFeedItem;
      storyGroup: VerticalFeedGroup;
      storyComponent: VerticalFeedItemComponent;
    }

    export interface VerticalFeedGroup {
      id: string;
      title: string;
      iconUrl?: string;
      index: number;
      pinned: boolean;
      seen: boolean;
      feedList: VerticalFeedItem[];
      type: string,
      name: string,
      nudge: boolean,
      style?: StoryGroupStyle,
    }

    export interface VerticalFeedItem {
      id: string;
      index: number;
      title: string;
      name: string;
      seen: boolean;
      currentTime: number;
      actionUrl: string;
      previewUrl: string;
      verticalFeedItemComponentList?: VerticalFeedItemComponent[];
      actionProducts?: STRProductItem[];
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

  export interface VerticalFeedGroupStyle {
    borderUnseenColors?: [string],
    textUnseenColor?: string,
    badge?: VerticalFeedGroupBadgeStyle,
  }
  
  export interface VerticalFeedGroupBadgeStyle {
    backgroundColor?: string,
    textColor?: string,
    endTime?: number,
    template?: string,
    text?: string,
  }

  export class VerticalFeedBar extends Component<VerticalFeedBar.Props> {
    refresh: () => void;
    pauseStory: () => void;
    resumeStory: () => void;
    closeStory: () => void;
    open: (uri: string) => void;
    openWithId: (groupId: string, itemId?: string, playMode?: String) => void;
    hydrateProducts: (products: STRProductItem[]) => void;
    hydrateWishlist: (products: STRProductItem[]) => void;
    updateCart: (cart: STRCart) => void;
    approveCartChange: (responseId: string, cart: STRCart) => void;
    rejectCartChange: (responseId: string, failMessage: string) => void;
    approveWishlistChange: (responseId: string, item: STRProductItem) => void;
    rejectWishlistChange: (responseId: string, failMessage: string) => void;
  }

  export namespace VerticalFeed {
    export interface Props extends ViewProps {
      storylyId: string;
      customParameter?: string;
      storylyTestMode?: boolean;
      storylySegments?: string[];
      storylyUserProperty?: Record<string, string>;
      storylyLayoutDirection?: "ltr" | "rtl";
      storylyLocale?: string;
      storylyMaxItemCount?: number;

      //ShareConfig
      storylyShareUrl?: string;
      storylyFacebookAppID?: string;

      //BarStyling
      verticalFeedGroupListSections?: number;
      verticalFeedGroupListHorizontalEdgePadding?: number;
      verticalFeedGroupListVerticalEdgePadding?: number;
      verticalFeedGroupListHorizontalPaddingBetweenItems?: number;
      verticalFeedGroupListVerticalPaddingBetweenItems?: number;

      //GroupStyling
      verticalFeedGroupIconHeight?: number;
      verticalFeedGroupIconCornerRadius?: number;
      verticalFeedGroupIconBackgroundColor?: string;
      verticalFeedGroupTextSize?: number;
      verticalFeedGroupTextIsVisible?: boolean;
      verticalFeedGroupTextTypeface?: string;
      verticalFeedGroupTextColor?: string;
      verticalFeedTypeIndicatorIsVisible?: boolean;
      verticalFeedGroupOrder?: "static" |"bySeenState" ;
      verticalFeedGroupMinLikeCountToShowIcon?: number;
      verticalFeedGroupMinImpressionCountToShowIcon?: number;
      verticalFeedGroupImpressionIcon?: string;
      verticalFeedGroupLikeIcon?: string;

      //VerticalFeedCustomization
      verticalFeedItemTextTypeface?: string;
      verticalFeedItemInteractiveTextTypeface?: string;
      verticalFeedItemProgressBarColor?: string[];
      verticalFeedItemTitleVisibility?: boolean;
      verticalFeedItemProgressBarVisibility?: boolean;
      verticalFeedItemCloseButtonIsVisible?: boolean;
      verticalFeedItemLikeButtonIsVisible?: boolean;
      verticalFeedItemShareButtonIsVisible?: boolean;
      verticalFeedItemCloseIcon?: string;
      verticalFeedItemShareIcon?: string;
      verticalFeedItemLikeIcon?: string;

      //ProductConfig
      verticalFeedFallbackIsEnabled?: boolean;
      verticalFeedCartIsEnabled?: boolean;
      verticalFeedProductFeed?: Record<string, STRProductItem[]>;

      onLoad?: (event: VerticalFeedLoadEvent) => void;
      onFail?: (event: string) => void;
      onVerticalFeedOpen?: () => void;
      onVerticalFeedClose?: () => void;
      onEvent?: (event: VerticalFeedEvent) => void;
      onPress?: (event: VerticalFeedPressEvent) => void;
      onUserInteracted?: (event: VerticalFeedItemInteractiveEvent) => void;
      onProductHydration?: (event: VerticalFeedProductHydrationEvent) => void;
      onCartUpdate?: (event: VerticalFeedProductCartUpdateEvent) => void;
      onWishlistUpdate?: (event: VerticalFeedWishlistUpdateEvent) => void;
      onProductEvent?: (event: ProductEvent) => void;
    }

    export interface VerticalFeedLoadEvent {
      feedGroupList: VerticalFeedGroup[];
      dataSource: string;
    }

    export interface VerticalFeedFailEvent {
      errorMessage: string;
    }

    export interface VerticalFeedPressEvent {
      feedItem: VerticalFeedItem;
    }

    export interface VerticalFeedEvent {
      event: string;
      feedItem?: VerticalFeedItem;
      feedGroup?: VerticalFeedGroup;
      feedItemComponent?: VerticalFeedItemComponent;
    }

    export interface VerticalFeedProductHydrationEvent {
      products: STRProductInformation[];
    }

    export interface VerticalFeedProductCartUpdateEvent {
      event: string;
      cart: STRCart;
      change: STRCartItem;
      responseId: string;
    }

    export interface VerticalFeedWishlistUpdateEvent {
      event: string;
      item: STRProductItem;
      responseId: string;
    }

    export interface ProductEvent {
      event: string;
    }

    export interface VerticalFeedHydrationEvent {
      event: string;
      feedItem?: VerticalFeedItem;
      feedGroup?: VerticalFeedGroup;
      feedItemComponent?: VerticalFeedItemComponent;
    }

    export interface VerticalFeedItemComponent {
      id: string;
      type: ReactionType;
      customPayload?: string;
    }

    export interface VerticalFeedItemSwipeComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemButtonComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemProductTagComponent extends VerticalFeedItemComponent {
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemProductCardComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemProductCatalogComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrlList?: string[];
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemQuizComponent extends VerticalFeedItemComponent {
      title: string;
      options: string[];
      rightAnswerIndex?: number;
      selectedOptionIndex: number;
      customPayload?: string;
    }

    export interface VerticalFeedItemPollComponent extends VerticalFeedItemComponent {
      title: string;
      emojiCodes: string[];
      selectedEmojiIndex: number;
      customPayload?: string;
    }

    export interface VerticalFeedItemRatingComponent extends VerticalFeedItemComponent {
      title: string;
      emojiCodes: string[];
      selectedEmojiIndex: number;
      customPayload?: string;
    }

    export interface VerticalFeedItemPromoCodeComponent extends VerticalFeedItemComponent {
      text: string;
    }

    export interface VerticalFeedItemCommentComponent extends VerticalFeedItemComponent {
      text: string;
    }

    export interface VerticalFeedItemInteractiveEvent {
      story: VerticalFeedItem;
      storyGroup: VerticalFeedGroup;
      storyComponent: VerticalFeedItemComponent;
    }

    export interface VerticalFeedGroup {
      id: string;
      title: string;
      iconUrl?: string;
      index: number;
      pinned: boolean;
      seen: boolean;
      feedList: VerticalFeedItem[];
      type: string,
      name: string,
      nudge: boolean,
      style?: StoryGroupStyle,
    }

    export interface VerticalFeedItem {
      id: string;
      index: number;
      title: string;
      name: string;
      seen: boolean;
      currentTime: number;
      actionUrl: string;
      previewUrl: string;
      verticalFeedItemComponentList?: VerticalFeedItemComponent[];
      actionProducts?: STRProductItem[];
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

  export interface VerticalFeedGroupStyle {
    borderUnseenColors?: [string],
    textUnseenColor?: string,
    badge?: VerticalFeedGroupBadgeStyle,
  }
  
  export interface VerticalFeedGroupBadgeStyle {
    backgroundColor?: string,
    textColor?: string,
    endTime?: number,
    template?: string,
    text?: string,
  }

  export class VerticalFeed extends Component<VerticalFeed.Props> {
    refresh: () => void;
    pauseStory: () => void;
    resumeStory: () => void;
    closeStory: () => void;
    open: (uri: string) => void;
    openWithId: (groupId: string, itemId?: string, playMode?: String) => void;
    hydrateProducts: (products: STRProductItem[]) => void;
    hydrateWishlist: (products: STRProductItem[]) => void;
    updateCart: (cart: STRCart) => void;
    approveCartChange: (responseId: string, cart: STRCart) => void;
    rejectCartChange: (responseId: string, failMessage: string) => void;
    approveWishlistChange: (responseId: string, item: STRProductItem) => void;
    rejectWishlistChange: (responseId: string, failMessage: string) => void;
  }

  export namespace VerticalFeedPresenter {
    export interface Props extends ViewProps {
      storylyId: string;
      customParameter?: string;
      storylyTestMode?: boolean;
      storylySegments?: string[];
      storylyUserProperty?: Record<string, string>;
      storylyLayoutDirection?: "ltr" | "rtl";
      storylyLocale?: string;
      storylyMaxItemCount?: number;

      //ShareConfig
      storylyShareUrl?: string;
      storylyFacebookAppID?: string;

      //BarStyling
      verticalFeedGroupListSections?: number;
      verticalFeedGroupListHorizontalEdgePadding?: number;
      verticalFeedGroupListVerticalEdgePadding?: number;
      verticalFeedGroupListHorizontalPaddingBetweenItems?: number;
      verticalFeedGroupListVerticalPaddingBetweenItems?: number;

      //GroupStyling
      verticalFeedGroupIconHeight?: number;
      verticalFeedGroupIconCornerRadius?: number;
      verticalFeedGroupIconBackgroundColor?: string;
      verticalFeedGroupTextSize?: number;
      verticalFeedGroupTextIsVisible?: boolean;
      verticalFeedGroupTextTypeface?: string;
      verticalFeedGroupTextColor?: string;
      verticalFeedTypeIndicatorIsVisible?: boolean;
      verticalFeedGroupOrder?: "static" |"bySeenState" ;
      verticalFeedGroupMinLikeCountToShowIcon?: number;
      verticalFeedGroupMinImpressionCountToShowIcon?: number;
      verticalFeedGroupImpressionIcon?: string;
      verticalFeedGroupLikeIcon?: string;

      //VerticalFeedCustomization
      verticalFeedItemTextTypeface?: string;
      verticalFeedItemInteractiveTextTypeface?: string;
      verticalFeedItemProgressBarColor?: string[];
      verticalFeedItemTitleVisibility?: boolean;
      verticalFeedItemProgressBarVisibility?: boolean;
      verticalFeedItemCloseButtonIsVisible?: boolean;
      verticalFeedItemLikeButtonIsVisible?: boolean;
      verticalFeedItemShareButtonIsVisible?: boolean;
      verticalFeedItemCloseIcon?: string;
      verticalFeedItemShareIcon?: string;
      verticalFeedItemLikeIcon?: string;

      //ProductConfig
      verticalFeedFallbackIsEnabled?: boolean;
      verticalFeedCartIsEnabled?: boolean;
      verticalFeedProductFeed?: Record<string, STRProductItem[]>;

      onLoad?: (event: VerticalFeedLoadEvent) => void;
      onFail?: (event: string) => void;
      onVerticalFeedOpen?: () => void;
      onVerticalFeedClose?: () => void;
      onEvent?: (event: VerticalFeedEvent) => void;
      onPress?: (event: VerticalFeedPressEvent) => void;
      onUserInteracted?: (event: VerticalFeedItemInteractiveEvent) => void;
      onProductHydration?: (event: VerticalFeedProductHydrationEvent) => void;
      onCartUpdate?: (event: VerticalFeedProductCartUpdateEvent) => void;
      onWishlistUpdate?: (event: VerticalFeedWishlistUpdateEvent) => void;
      onProductEvent?: (event: ProductEvent) => void;
    }

    export interface VerticalFeedLoadEvent {
      feedGroupList: VerticalFeedGroup[];
      dataSource: string;
    }

    export interface VerticalFeedFailEvent {
      errorMessage: string;
    }

    export interface VerticalFeedPressEvent {
      feedItem: VerticalFeedItem;
    }

    export interface VerticalFeedEvent {
      event: string;
      feedItem?: VerticalFeedItem;
      feedGroup?: VerticalFeedGroup;
      feedItemComponent?: VerticalFeedItemComponent;
    }

    export interface VerticalFeedProductHydrationEvent {
      products: STRProductInformation[];
    }

    export interface VerticalFeedProductCartUpdateEvent {
      event: string;
      cart: STRCart;
      change: STRCartItem;
      responseId: string;
    }

    export interface VerticalFeedWishlistUpdateEvent {
      event: string;
      item: STRProductItem;
      responseId: string;
    }

    export interface ProductEvent {
      event: string;
    }

    export interface VerticalFeedHydrationEvent {
      event: string;
      feedItem?: VerticalFeedItem;
      feedGroup?: VerticalFeedGroup;
      feedItemComponent?: VerticalFeedItemComponent;
    }

    export interface VerticalFeedItemComponent {
      id: string;
      type: ReactionType;
      customPayload?: string;
    }

    export interface VerticalFeedItemSwipeComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemButtonComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemProductTagComponent extends VerticalFeedItemComponent {
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemProductCardComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrl?: string;
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemProductCatalogComponent extends VerticalFeedItemComponent {
      text: string;
      actionUrlList?: string[];
      products?: STRProductItem[];
    }

    export interface VerticalFeedItemQuizComponent extends VerticalFeedItemComponent {
      title: string;
      options: string[];
      rightAnswerIndex?: number;
      selectedOptionIndex: number;
      customPayload?: string;
    }

    export interface VerticalFeedItemPollComponent extends VerticalFeedItemComponent {
      title: string;
      emojiCodes: string[];
      selectedEmojiIndex: number;
      customPayload?: string;
    }

    export interface VerticalFeedItemRatingComponent extends VerticalFeedItemComponent {
      title: string;
      emojiCodes: string[];
      selectedEmojiIndex: number;
      customPayload?: string;
    }

    export interface VerticalFeedItemPromoCodeComponent extends VerticalFeedItemComponent {
      text: string;
    }

    export interface VerticalFeedItemCommentComponent extends VerticalFeedItemComponent {
      text: string;
    }

    export interface VerticalFeedItemInteractiveEvent {
      story: VerticalFeedItem;
      storyGroup: VerticalFeedGroup;
      storyComponent: VerticalFeedItemComponent;
    }

    export interface VerticalFeedGroup {
      id: string;
      title: string;
      iconUrl?: string;
      index: number;
      pinned: boolean;
      seen: boolean;
      feedList: VerticalFeedItem[];
      type: string,
      name: string,
      nudge: boolean,
      style?: StoryGroupStyle,
    }

    export interface VerticalFeedItem {
      id: string;
      index: number;
      title: string;
      name: string;
      seen: boolean;
      currentTime: number;
      actionUrl: string;
      previewUrl: string;
      verticalFeedItemComponentList?: VerticalFeedItemComponent[];
      actionProducts?: STRProductItem[];
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

  export interface VerticalFeedGroupStyle {
    borderUnseenColors?: [string],
    textUnseenColor?: string,
    badge?: VerticalFeedGroupBadgeStyle,
  }
  
  export interface VerticalFeedGroupBadgeStyle {
    backgroundColor?: string,
    textColor?: string,
    endTime?: number,
    template?: string,
    text?: string,
  }

  export class VerticalFeedPresenter extends Component<VerticalFeedPresenter.Props> {
    refresh: () => void;
    play: () => void;
    pause: () => void;
    hydrateProducts: (products: STRProductItem[]) => void;
    hydrateWishlist: (products: STRProductItem[]) => void;
    updateCart: (cart: STRCart) => void;
    approveCartChange: (responseId: string, cart: STRCart) => void;
    rejectCartChange: (responseId: string, failMessage: string) => void;
    approveWishlistChange: (responseId: string, item: STRProductItem) => void;
    rejectWishlistChange: (responseId: string, failMessage: string) => void;
  }
}
