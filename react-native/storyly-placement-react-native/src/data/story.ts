/**
 * Storyly Placement - Product and Cart Data Models
 * Based on StorylyPlacement iOS SDK
 */

// MARK: - Product Types

export interface STRProductVariant {
  name: string;
  value: string;
  key: string;
}

export interface STRProductItem {
  productId: string;
  productGroupId?: string;
  title?: string;
  desc?: string;
  price: number;
  salesPrice?: number;
  currency: string;
  url?: string;
  imageUrls?: string[];
  variants?: STRProductVariant[];
  ctaText?: string;
}

export interface STRProductInformation {
  productId?: string;
  productGroupId?: string;
}

// MARK: - Cart Types

export interface STRCartItem {
  item: STRProductItem;
  quantity: number;
  totalPrice?: number;
  oldTotalPrice?: number;
}

export interface STRCart {
  items: STRCartItem[];
  totalPrice: number;
  oldTotalPrice?: number;
  currency: string;
}

// MARK: - Placement Widget Types

export type PlacementWidgetType = 'storyBar' | 'videoFeed' | 'banner' | 'swipeCard';

// MARK: - Banner Types

export interface STRBannerItem {
  id: string;
  index: number;
  title?: string;
  actionUrl?: string;
  actionProducts?: string[];
}

export interface STRBannerPayload {
  item?: STRBannerItem;
  component?: STRPlacementComponent;
}

// MARK: - StoryBar Types

export interface STRStoryGroup {
  id: string;
  title: string;
  iconUrl?: string;
  index: number;
  pinned: boolean;
  seen: boolean;
  stories: STRStory[];
  type: string;
  name?: string;
  nudge: boolean;
  style?: STRStoryGroupStyle;
}

export interface STRStory {
  id: string;
  index: number;
  title: string;
  name?: string;
  seen: boolean;
  currentTime?: number;
  actionUrl?: string;
  previewUrl?: string;
  storyComponentList?: STRPlacementComponent[];
  actionProducts?: STRProductItem[];
}

export interface STRStoryGroupStyle {
  borderUnseenColors?: string[];
  textUnseenColor?: string;
  badge?: STRStoryGroupBadgeStyle;
}

export interface STRStoryGroupBadgeStyle {
  backgroundColor?: string;
  textColor?: string;
  endTime?: number;
  template?: string;
  text?: string;
}

export interface STRStoryBarPayload {
  group?: STRStoryGroup;
  story?: STRStory;
  component?: STRPlacementComponent;
}

// MARK: - VideoFeed Types

export interface STRVideoFeedGroup {
  id: string;
  title: string;
  iconUrl?: string;
  index: number;
  feedItems: STRVideoFeedItem[];
}

export interface STRVideoFeedItem {
  id: string;
  index: number;
  title?: string;
  actionUrl?: string;
  actionProducts?: string[];
  previewUrl?: string;
}

export interface STRVideoFeedPayload {
  group?: STRVideoFeedGroup;
  feedItem?: STRVideoFeedItem;
  component?: STRPlacementComponent;
}

// MARK: - SwipeCard Types

export interface STRSwipeCard {
  id: string;
  index: number;
  title?: string;
  actionUrl?: string;
  actionProducts?: string[];
  previewUrl?: string;
}

export interface STRSwipeCardPayload {
  card?: STRSwipeCard;
  component?: STRPlacementComponent;
}

// MARK: - Component Types

export type PlacementComponentType =
  | 'button'
  | 'swipe'
  | 'productTag'
  | 'productCard'
  | 'productCatalog'
  | 'text'
  | 'image'
  | 'video';

export interface STRPlacementComponent {
  id: string;
  type: PlacementComponentType;
  customPayload?: string;
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}


