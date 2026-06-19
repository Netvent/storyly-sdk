import { NativeModules, Platform } from 'react-native';

export interface StorylyAnalyticsNative {
  // Initializes the analytics module with the given config JSON.
  initialize(config: string): void;

  // Tracks a product analytics event from the given event JSON.
  track(event: string): void;
}

const LINKING_ERROR =
  `The package 'storyly-placement-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const NativeModule = (() => {
  try {
    return require('./newarch/NativeStorylyAnalytics')
      .default as StorylyAnalyticsNative;
  } catch (error) {
    return NativeModules.StorylyAnalytics as StorylyAnalyticsNative;
  }
})();

export default NativeModule
  ? NativeModule
  : (new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    ) as StorylyAnalyticsNative);
