/**
 * Configuration required to initialize Storyly Analytics.
 *
 * Mirrors the native `STRAnalyticsConfig`.
 */
export interface STRAnalyticsConfig {
  /** The unique API token identifying the Storyly account for analytics tracking. */
  token: string;
  /** An optional unique user identifier for associating events with a specific user. */
  userId?: string;
}

/**
 * A product involved in a Storyly Analytics event.
 *
 * Mirrors the native `STRAnalyticProduct`.
 */
export interface STRAnalyticProduct {
  /** The unique identifier of the product (e.g. SKU or product feed ID). */
  productId: string;
  /** The unique identifier of the product group this product belongs to. */
  productGroupId: string;
  /** The display title or name of the product. */
  title: string;
  /** An optional description of the product. */
  desc?: string;
  /** The original (regular) price of the product. */
  price: number;
  /** The discounted/sale price of the product. */
  salesPrice?: number;
  /** The number of units of this product involved in the event. Defaults to 1. */
  quantity?: number;
}

/**
 * The types of product analytics events that can be tracked.
 *
 * The string values match the native enum names and are sent over the bridge.
 */
export enum STRAnalyticProductEvent {
  PDPViewed = 'PDPViewed',
  CartAdded = 'CartAdded',
  WishlistAdded = 'WishlistAdded',
  Purchased = 'Purchased',
}
