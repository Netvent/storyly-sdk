/**
 * Storyly Analytics - Personalization Engine Module
 *
 * Lightweight module for tracking product-related events (views, cart
 * additions, wishlist additions, purchases) to enhance personalization.
 */

import type {
  STRAnalyticsConfig,
  STRAnalyticProduct,
  STRAnalyticProductEvent,
} from './data';
import StorylyAnalyticsNative from './native/StorylyAnalyticsNative';

export const StorylyAnalytics = {
  /**
   * Initializes the Storyly Analytics module with the provided configuration.
   * Call once during application startup, before tracking any events.
   */
  initialize(config: STRAnalyticsConfig): void {
    StorylyAnalyticsNative.initialize(JSON.stringify(config));
  },

  /**
   * Tracks a product analytics event involving one or more products.
   */
  track(event: STRAnalyticProductEvent, products: STRAnalyticProduct[]): void {
    StorylyAnalyticsNative.track(JSON.stringify({ event, products }));
  },

  /**
   * Tracks a product analytics event involving a single product.
   * Convenience wrapper around `track`.
   */
  trackProduct(
    event: STRAnalyticProductEvent,
    product: STRAnalyticProduct
  ): void {
    StorylyAnalytics.track(event, [product]);
  },
};
