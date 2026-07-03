import type { STRDataPayload, STRPayload } from '../events';
import type { STRProductItem } from '../product';


export interface SwipeCard {
  actionProducts?: STRProductItem[];
}

export interface SwipeCardDataPayload extends STRDataPayload {
  items: SwipeCard;
}

export interface STRSwipeCardPayload extends STRPayload {
  card?: SwipeCard;
}

