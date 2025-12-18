import { NativeModules, Platform } from 'react-native';
import type { StorylyPlacementProviderNative } from './StorylyPlacementNativeTypes';


const LINKING_ERROR =
  `The package 'storyly-placement-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const NativeModule = (() => {
    try {
      return require('./newarch/NativeStorylyPlacementProvider').default as StorylyPlacementProviderNative;
    } catch (error) {
      return NativeModules.StorylyPlacementProvider as StorylyPlacementProviderNative;
    }
})()

export default NativeModule
      ? NativeModule
      : new Proxy(
          {},
          {
            get() {
              throw new Error(LINKING_ERROR);
            },
          }
        ) as StorylyPlacementProviderNative;


