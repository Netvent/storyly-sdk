/**
 * Storyly Placement - Event Types
 * Based on StorylyPlacement iOS SDK delegate callbacks
 */

import type { STRCart, STRCartItem, STRProductItem } from '../product';
import type { BaseEvent } from '../util';
import type { PlacementWidgetType, STRErrorPayload, STREventPayload, STRPayload } from './payloads';


export interface PlacementWidgetReadyEvent extends BaseEvent {
  widget: PlacementWidgetType;
  ratio: number;
}

export interface PlacementActionClickEvent extends BaseEvent {
  widget: PlacementWidgetType;
  url: string;
  payload?: STRPayload;
}

export interface PlacementEvent extends BaseEvent {
  widget: PlacementWidgetType;
  payload: STREventPayload;
}

export interface PlacementFailEvent extends BaseEvent {
  widget: PlacementWidgetType;
  payload: STRErrorPayload;
}

// MARK: - Product Events

export interface PlacementProductEvent extends BaseEvent {
  widget: PlacementWidgetType;
  event: string;
}

export interface PlacementCartUpdateEvent extends BaseEvent {
  widget: PlacementWidgetType;
  event: string;
  cart?: STRCart;
  change?: STRCartItem;
  responseId: string;
}

export interface PlacementWishlistUpdateEvent extends BaseEvent {
  widget: PlacementWidgetType;
  event: string;
  item?: STRProductItem;
  responseId: string;
}