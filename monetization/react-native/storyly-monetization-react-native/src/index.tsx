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

export const setStorylyAdViewProvider = function(reactView: React.Component, params: string) {
  let id = findNodeHandle(reactView);
  console.log(id);
  StorylyMonetization.setAdViewProvider(id, params);
}

