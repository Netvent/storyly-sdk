import { NativeModules, Platform, findNodeHandle } from 'react-native';

const LINKING_ERROR =
  `The package 'storyly-monetization-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const StorylyMonetization = NativeModules.RNStorylyMonetization
  ? NativeModules.RNStorylyMonetization
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export interface StorylyAdViewProvider {
  adMobAdUnitId: string
  adMobAdExtras?: Map<string, any>
}

export const setStorylyAdViewProvider = function(reactView: React.Component, storylyAdViewProvider?: StorylyAdViewProvider) {
  let id = findNodeHandle(reactView);
  StorylyMonetization.setAdViewProvider(id, storylyAdViewProvider);
}

