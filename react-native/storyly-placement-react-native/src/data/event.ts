/**
 * Storyly Placement - Event Types
 * Based on StorylyPlacement iOS SDK delegate callbacks
 */

import type {
  STRBannerItem,
  STRBannerPayload,
  STRCart,
  STRCartItem,
  STRPlacementComponent,
  STRProductInformation,
  STRProductItem,
  STRStory,
  STRStoryBarPayload,
  STRStoryGroup,
  STRSwipeCard,
  STRSwipeCardPayload,
  STRVideoFeedGroup,
  STRVideoFeedItem,
  STRVideoFeedPayload,
} from './story';

// MARK: - Base Event

export interface BaseEvent {}

// MARK: - Provider Events

export interface PlacementLoadEvent extends BaseEvent {
  dataSource: string;
}

export interface PlacementLoadFailEvent extends BaseEvent {
  errorMessage: string;
}

export interface PlacementHydrationEvent extends BaseEvent {
  products: STRProductInformation[];
}

// MARK: - Widget Ready Event

export interface PlacementWidgetReadyEvent extends BaseEvent {
  ratio: number;
}

// MARK: - Action Click Events

export interface PlacementActionClickEvent extends BaseEvent {
  url: string;
}

export interface BannerActionClickEvent extends PlacementActionClickEvent {
  banner: STRBannerPayload;
}

export interface StoryBarActionClickEvent extends PlacementActionClickEvent {
  storyBar: STRStoryBarPayload;
}

export interface VideoFeedActionClickEvent extends PlacementActionClickEvent {
  videoFeed: STRVideoFeedPayload;
}

export interface SwipeCardActionClickEvent extends PlacementActionClickEvent {
  swipeCard: STRSwipeCardPayload;
}

// MARK: - Widget Events

// Banner Events
export type BannerEventType =
  | 'BannerViewed'
  | 'BannerCompleted'
  | 'BannerImpression';

export interface BannerEvent extends BaseEvent {
  event: BannerEventType;
  banner?: STRBannerItem;
  component?: STRPlacementComponent;
}

// StoryBar Events
export type StoryBarEventType =
  | 'StoryShown'
  | 'StoryDismissed'
  | 'StoryViewed'
  | 'StoryProductAdded'
  | 'StoryProductUpdated'
  | 'StoryProductRemoved';

export interface StoryBarEvent extends BaseEvent {
  event: StoryBarEventType;
  storyGroup?: STRStoryGroup;
  story?: STRStory;
  component?: STRPlacementComponent;
}

// VideoFeed Events
export type VideoFeedEventType =
  | 'VideoFeedGroupOpened'
  | 'VideoFeedGroupClosed'
  | 'VideoFeedItemViewed'
  | 'VideoFeedItemProductAdded'
  | 'VideoFeedItemProductUpdated'
  | 'VideoFeedItemProductRemoved';

export interface VideoFeedEvent extends BaseEvent {
  event: VideoFeedEventType;
  group?: STRVideoFeedGroup;
  feedItem?: STRVideoFeedItem;
  component?: STRPlacementComponent;
}

// SwipeCard Events
export type SwipeCardEventType =
  | 'SwipeCardViewed'
  | 'CardViewed'
  | 'CardClicked'
  | 'CardActionClicked'
  | 'CardStackCompleted'
  | 'CardSwipedInterested'
  | 'CardSwipedIgnored';

export interface SwipeCardEvent extends BaseEvent {
  event: SwipeCardEventType;
  card?: STRSwipeCard;
  component?: STRPlacementComponent;
}

// MARK: - Error Events

export interface PlacementFailEvent extends BaseEvent {
  errorMessage: string;
}

// MARK: - Product Events

export interface PlacementProductEvent extends BaseEvent {
  event: string;
}

// MARK: - Cart Events

export interface PlacementCartUpdateEvent extends BaseEvent {
  event: string;
  cart?: STRCart;
  change?: STRCartItem;
  responseId: string;
}

// MARK: - Wishlist Events

export interface PlacementWishlistUpdateEvent extends BaseEvent {
  event: string;
  item?: STRProductItem;
  responseId: string;
}

// MARK: - Union Types for Casting

/**
 * Union type for all widget events
 * Use type guards or cast based on widgetType field
 */
export type PlacementWidgetEvent = BannerEvent | StoryBarEvent | VideoFeedEvent | SwipeCardEvent;

/**
 * Union type for all action click events
 * Use type guards or cast based on the payload property
 */
export type PlacementActionEvent =
  | BannerActionClickEvent
  | StoryBarActionClickEvent
  | VideoFeedActionClickEvent
  | SwipeCardActionClickEvent;

// MARK: - Generic Placement Event

export interface PlacementEvent extends BaseEvent {
  event: string;
  widgetType: string;
  payload?: Record<string, unknown>;
}

