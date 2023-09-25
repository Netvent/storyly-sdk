import type { StoryGroup, Story, StoryComponent, STRCart, STRCartItem } from "./story";

export interface BaseEvent {}

export interface StoryLoadEvent extends BaseEvent {
  storyGroupList: StoryGroup[];
  dataSource: string;
}

export interface StoryFailEvent extends BaseEvent {
  errorMessage: string;
}

export interface StoryPressEvent extends BaseEvent {
  story: Story;
}

export interface StoryPresentFail extends BaseEvent {
  errorMessage: string;
}

export interface StoryEvent extends BaseEvent {
  event: string;
  story?: Story;
  storyGroup?: StoryGroup;
  storyComponent?: StoryComponent;
}

export interface StoryProductHydrationEvent extends BaseEvent {
  productIds: string[];
}

export interface StoryProductCartUpdateEvent extends BaseEvent {
  event: string;
  cart: STRCart;
  change: STRCartItem;
  responseId: string;
}

export interface ProductEvent extends BaseEvent {
  event: string;
}

export interface StoryHydrationEvent extends BaseEvent {
  event: string;
  story?: Story;
  storyGroup?: StoryGroup;
  storyComponent?: StoryComponent;
}

export interface StoryInteractiveEvent extends BaseEvent {
  story: Story;
  storyGroup: StoryGroup;
  storyComponent: StoryComponent;
}