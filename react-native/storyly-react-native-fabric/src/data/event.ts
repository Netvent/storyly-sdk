import type { StoryGroup, Story, StoryComponent, STRCart, STRCartItem } from "./story";


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

export interface StoryPresentFail {
  errorMessage: string;
}

export interface StoryEvent {
  event: string;
  story?: Story;
  storyGroup?: StoryGroup;
  storyComponent?: StoryComponent;
}

export interface StoryProductHydrationEvent {
  productIds: string[];
}

export interface StoryProductCartUpdateEvent {
  event: string;
  cart: STRCart;
  change: STRCartItem;
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

export interface StoryInteractiveEvent {
  story: Story;
  storyGroup: StoryGroup;
  storyComponent: StoryComponent;
}