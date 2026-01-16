import type { STRDataPayload, STRPayload } from '../events';
import type { STRProductItem } from '../product';


export type VideoFeedComponentType =
  | 'Button'
  | 'Swipe'
  | 'ProductTag'
  | 'ProductCard'
  | 'ProductCatalog'
  | 'Quiz'
  | 'ImageQuiz'
  | 'Poll'
  | 'Emoji'
  | 'Rating'
  | 'PromoCode'
  | 'Comment';


export interface VideoFeedComponent {
  type: VideoFeedComponentType;
  id: string;
  customPayload?: string;
}

export interface VideoFeedButtonComponent extends VideoFeedComponent {
  type: 'Button';
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface VideoFeedSwipeComponent extends VideoFeedComponent {
  type: 'Swipe';
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface VideoFeedProductTagComponent extends VideoFeedComponent {
  type: 'ProductTag';
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface VideoFeedProductCardComponent extends VideoFeedComponent {
  type: 'ProductCard';
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface VideoFeedProductCatalogComponent extends VideoFeedComponent {
  type: 'ProductCatalog';
  actionUrlList?: string[];
  products?: STRProductItem[];
}

export interface VideoFeedQuizComponent extends VideoFeedComponent {
  type: 'Quiz';
  title?: string;
  options?: string[];
  rightAnswerIndex?: number;
  selectedOptionIndex?: number;
}

export interface VideoFeedImageQuizComponent extends VideoFeedComponent {
  type: 'ImageQuiz';
  title?: string;
  options?: string[];
  rightAnswerIndex?: number;
  selectedOptionIndex?: number;
}

export interface VideoFeedPollComponent extends VideoFeedComponent {
  type: 'Poll';
  title?: string;
  options?: string[];
  selectedOptionIndex?: number;
}

export interface VideoFeedEmojiComponent extends VideoFeedComponent {
  type: 'Emoji';
  emojiCodes?: string[];
  selectedEmojiIndex?: number;
}

export interface VideoFeedRatingComponent extends VideoFeedComponent {
  type: 'Rating';
  emojiCode?: string;
  rating?: number;
}

export interface VideoFeedPromoCodeComponent extends VideoFeedComponent {
  type: 'PromoCode';
  text?: string;
}

export interface VideoFeedCommentComponent extends VideoFeedComponent {
  type: 'Comment';
  text?: string;
}

export type VideoFeedComponentUnion =
  | VideoFeedButtonComponent
  | VideoFeedSwipeComponent
  | VideoFeedProductTagComponent
  | VideoFeedProductCardComponent
  | VideoFeedProductCatalogComponent
  | VideoFeedQuizComponent
  | VideoFeedImageQuizComponent
  | VideoFeedPollComponent
  | VideoFeedEmojiComponent
  | VideoFeedRatingComponent
  | VideoFeedPromoCodeComponent
  | VideoFeedCommentComponent;


export interface STRVideoFeedGroup {
  id: string;
  title: string;
  name?: string;
  iconUrl?: string;
  index: number;
  seen: boolean;
  type: string;
  pinned: boolean;
  nudge: boolean;
  iconVideoUrl?: string;
  iconVideoThumbnailUrl?: string;
  feedList: STRVideoFeedItem[];
}

export interface STRVideoFeedItem {
  id: string;
  title?: string;
  name?: string;
  index: number;
  seen: boolean;
  previewUrl?: string;
  actionUrl?: string;
  actionProducts?: STRProductItem[];
  currentTime?: number;
  feedItemComponentList?: VideoFeedComponentUnion[];
}


export interface VideoFeedDataPayload extends STRDataPayload {
  items: STRVideoFeedGroup;
}

export interface STRVideoFeedPayload extends STRPayload {
  group?: STRVideoFeedGroup;
  feedItem?: STRVideoFeedItem;
  component?: VideoFeedComponentUnion;
}

