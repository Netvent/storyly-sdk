/**
 * Storyly Placement - Event Types
 * Based on StorylyPlacement iOS SDK delegate callbacks
 */

import type { STRCartItem, STRProductItem } from '../product';
import type { BaseEvent } from '../util';
import type { PlacementWidget, STRErrorPayload, STREventPayload, STRPayload } from './payloads';


export interface PlacementWidgetReadyEvent extends BaseEvent {
  widget: PlacementWidget;
  ratio: number;
}

export interface PlacementActionClickEvent extends BaseEvent {
  widget: PlacementWidget;
  url: string;
  payload?: STRPayload;
}

export interface PlacementEvent extends BaseEvent {
  widget: PlacementWidget;
  payload: STREventPayload;
}

export interface PlacementFailEvent extends BaseEvent {
  widget: PlacementWidget;
  payload: STRErrorPayload;
}

// MARK: - Product Events

export interface PlacementProductEvent extends BaseEvent {
  widget: PlacementWidget;
  event: string;
}

export interface PlacementCartUpdateEvent extends BaseEvent {
  widget: PlacementWidget;
  item?: STRCartItem;
  responseId: string;
}

export interface PlacementWishlistUpdateEvent extends BaseEvent {
  widget: PlacementWidget;
  event: string;
  item?: STRProductItem;
  responseId: string;
}