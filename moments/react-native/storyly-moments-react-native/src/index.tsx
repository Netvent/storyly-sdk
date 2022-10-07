import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'storyly-moments-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const StorylyMoments = NativeModules.RNStorylyMoments
  ? NativeModules.RNStorylyMoments
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const initialize = function(token: string, userPayload: string) {
  StorylyMoments.initialize(token, userPayload);
}

const openUserStories = function() {
  StorylyMoments.openUserStories()
}

const openStoryCreator = function() {
  StorylyMoments.openStoryCreator()
}

const encryptUserPayload = function(
  momentsUserPayload: StorylyMomentsUserPayload, 
  secretKey:string, 
  initializationVector: string
  ): Promise<string> {
  return StorylyMoments.encryptUserPayload(
    secretKey,
    initializationVector,
    momentsUserPayload.id,
    momentsUserPayload.username,
    momentsUserPayload.avatarUrl,
    momentsUserPayload.followings,
    momentsUserPayload.creatorTags,
    momentsUserPayload.consumerTags,
    momentsUserPayload.expirationTime
  );
};

export class StorylyMomentsUserPayload {
  id!: string;
  username!: string;
  avatarUrl!: string;
  followings!: string[];
  creatorTags?: string[];
  consumerTags?: string[];
  expirationTime!: number;
}

export default {
  ...StorylyMoments,
  ...StorylyMomentsUserPayload,
  initialize,
  openUserStories,
  openStoryCreator,
  encryptUserPayload,
}
