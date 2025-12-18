import type { STRDataPayload, STRPayload } from '../events';
import type { STRProductItem } from '../product';


export type VideoFeedComponentType =
  | 'button'
  | 'swipe'
  | 'productTag'
  | 'productCard'
  | 'productCatalog'
  | 'quiz'
  | 'imageQuiz'
  | 'poll'
  | 'emoji'
  | 'rating'
  | 'promoCode'
  | 'comment'
  | 'countDown';


export interface VideoFeedComponent {
  type: VideoFeedComponentType;
  id: string;
  customPayload?: string;
}

export interface VideoFeedButtonComponent extends VideoFeedComponent {
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface VideoFeedSwipeComponent extends VideoFeedComponent {
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface VideoFeedProductTagComponent extends VideoFeedComponent {
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface VideoFeedProductCardComponent extends VideoFeedComponent {
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface VideoFeedProductCatalogComponent extends VideoFeedComponent {
  actionUrlList?: string[];
  products?: STRProductItem[];
}

export interface VideoFeedQuizComponent extends VideoFeedComponent {
  title?: string;
  options?: string[];
  rightAnswerIndex?: number;
  selectedOptionIndex?: number;
}

export interface VideoFeedImageQuizComponent extends VideoFeedComponent {
  title?: string;
  options?: string[];
  rightAnswerIndex?: number;
  selectedOptionIndex?: number;
}

export interface VideoFeedPollComponent extends VideoFeedComponent {
  title?: string;
  options?: string[];
  selectedOptionIndex?: number;
}

export interface VideoFeedEmojiComponent extends VideoFeedComponent {
  emojiCodes?: string[];
  selectedEmojiIndex?: number;
}

export interface VideoFeedRatingComponent extends VideoFeedComponent {
  emojiCode?: string;
  rating?: number;
}

export interface VideoFeedPromoCodeComponent extends VideoFeedComponent {
  text?: string;
}

export interface VideoFeedCommentComponent extends VideoFeedComponent {
  text?: string;
}

export interface VideoFeedCountDownComponent extends VideoFeedComponent {
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
  | VideoFeedCommentComponent
  | VideoFeedCountDownComponent;


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
