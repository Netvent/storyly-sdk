import type { STRDataPayload, STRPayload } from '../events';
import type { STRProductItem } from '../product';


export type StoryBarComponentType =
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


export interface StoryBarComponent {
  type: StoryBarComponentType;
  id: string;
  customPayload?: string;
}

// Action Components
export interface StoryButtonComponent extends StoryBarComponent {
  type: 'Button';
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface StorySwipeComponent extends StoryBarComponent {
  type: 'Swipe';
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

// Product Components
export interface StoryProductTagComponent extends StoryBarComponent {
  type: 'ProductTag';
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface StoryProductCardComponent extends StoryBarComponent {
  type: 'ProductCard';
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface StoryProductCatalogComponent extends StoryBarComponent {
  type: 'ProductCatalog';
  actionUrlList?: string[];
  products?: STRProductItem[];
}

// Interactive Components
export interface StoryQuizComponent extends StoryBarComponent {
  type: 'Quiz';
  title?: string;
  options?: string[];
  rightAnswerIndex?: number;
  selectedOptionIndex?: number;
}

export interface StoryImageQuizComponent extends StoryBarComponent {
  type: 'ImageQuiz';
  title?: string;
  options?: string[];
  rightAnswerIndex?: number;
  selectedOptionIndex?: number;
}

export interface StoryPollComponent extends StoryBarComponent {
  type: 'Poll';
  title?: string;
  options?: string[];
  selectedOptionIndex?: number;
}

export interface StoryEmojiComponent extends StoryBarComponent {
  type: 'Emoji';
  emojiCodes?: string[];
  selectedEmojiIndex?: number;
}

export interface StoryRatingComponent extends StoryBarComponent {
  type: 'Rating';
  emojiCode?: string;
  rating?: number;
}

export interface StoryPromoCodeComponent extends StoryBarComponent {
  type: 'PromoCode';
  text?: string;
}

export interface StoryCommentComponent extends StoryBarComponent {
  type: 'Comment';
  text?: string;
}

export type StoryBarComponentUnion =
  | StoryButtonComponent
  | StorySwipeComponent
  | StoryProductTagComponent
  | StoryProductCardComponent
  | StoryProductCatalogComponent
  | StoryQuizComponent
  | StoryImageQuizComponent
  | StoryPollComponent
  | StoryEmojiComponent
  | StoryRatingComponent
  | StoryPromoCodeComponent
  | StoryCommentComponent;

// MARK: - StoryBar Widget Types

export interface STRStoryGroup {
  id: string;
  title: string;
  name?: string;
  iconUrl?: string;
  iconVideoUrl?: string;
  iconVideoThumbnailUrl?: string;
  index: number;
  pinned: boolean;
  seen: boolean;
  stories: STRStory[];
  type: string;
  nudge: boolean;
  style?: STRStoryGroupStyle;
}

export interface STRStory {
  id: string;
  title: string;
  name?: string;
  index: number;
  seen: boolean;
  previewUrl?: string;
  actionUrl?: string;
  actionProducts?: STRProductItem[];
  currentTime?: number;
  storyComponentList?: StoryBarComponentUnion[];
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


export interface StoryBarDataPayload extends STRDataPayload {
  items: STRStoryGroup[];
}

export interface STRStoryBarPayload extends STRPayload {
  group?: STRStoryGroup;
  story?: STRStory;
  component?: StoryBarComponentUnion;
}

