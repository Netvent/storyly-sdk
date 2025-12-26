import type { STRDataPayload, STRPayload } from '../events';
import type { STRProductItem } from '../product';


export interface STRSwipeCard {
  actionProducts?: STRProductItem[];
}

export interface SwipeCardDataPayload extends STRDataPayload {
  items: STRSwipeCard;
}

export interface STRSwipeCardPayload extends STRPayload {
  card?: STRSwipeCard;
}

