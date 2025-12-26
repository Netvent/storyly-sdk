import type { STRDataPayload, STRPayload } from '../events';
import type { STRProductItem } from '../product';


export type StoryBarComponentType =
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


export interface StoryBarComponent {
  type: StoryBarComponentType;
  id: string;
  customPayload?: string;
}

// Action Components
export interface StoryButtonComponent extends StoryBarComponent {
  type: 'button';
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface StorySwipeComponent extends StoryBarComponent {
  type: 'swipe';
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

// Product Components
export interface StoryProductTagComponent extends StoryBarComponent {
  type: 'productTag';
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface StoryProductCardComponent extends StoryBarComponent {
  type: 'productCard';
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export interface StoryProductCatalogComponent extends StoryBarComponent {
  type: 'productCatalog';
  actionUrlList?: string[];
  products?: STRProductItem[];
}

// Interactive Components
export interface StoryQuizComponent extends StoryBarComponent {
  type: 'quiz';
  title?: string;
  options?: string[];
  rightAnswerIndex?: number;
  selectedOptionIndex?: number;
}

export interface StoryImageQuizComponent extends StoryBarComponent {
  type: 'imageQuiz';
  title?: string;
  options?: string[];
  rightAnswerIndex?: number;
  selectedOptionIndex?: number;
}

export interface StoryPollComponent extends StoryBarComponent {
  type: 'poll';
  title?: string;
  options?: string[];
  selectedOptionIndex?: number;
}

export interface StoryEmojiComponent extends StoryBarComponent {
  type: 'emoji';
  emojiCodes?: string[];
  selectedEmojiIndex?: number;
}

export interface StoryRatingComponent extends StoryBarComponent {
  type: 'rating';
  emojiCode?: string;
  rating?: number;
}

export interface StoryPromoCodeComponent extends StoryBarComponent {
  type: 'promoCode';
  text?: string;
}

export interface StoryCommentComponent extends StoryBarComponent {
  type: 'comment';
  text?: string;
}

export interface StoryCountDownComponent extends StoryBarComponent {
  type: 'countDown';
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
  | StoryCommentComponent
  | StoryCountDownComponent;

// MARK: - StoryBar Widget Types

export interface STRStoryGroup {
  id: string;
  title: string;
  name?: string;
  iconUrl?: string;
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
