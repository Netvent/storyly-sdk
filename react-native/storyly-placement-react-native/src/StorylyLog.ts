/**
 * Storyly Log - log level control for the placement SDK.
 *
 * Logs are off by default. Setting a level applies to both the
 * cross-platform wrapper and the native Storyly Placement SDK.
 */

import StorylyPlacementProviderNative from './native/StorylyPlacementProviderNative';

export type STRLogLevel = 'debug' | 'warning' | 'error' | 'off';

export const StorylyLog = {
  /**
   * Sets the minimum log level for Storyly Placement.
   * `debug` is the most verbose, `off` (default) silences all output.
   */
  setLogLevel(level: STRLogLevel): void {
    StorylyPlacementProviderNative.setLogLevel(level);
  },
};
