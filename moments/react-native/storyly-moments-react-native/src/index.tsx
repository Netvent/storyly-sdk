import { NativeModules, Platform, NativeEventEmitter, EmitterSubscription } from 'react-native';

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

const initialize = function(token: String, userPayload: String) {
  StorylyMoments.initialize(token, userPayload);
}

const openUserStories = function() {
  StorylyMoments.openUserStories()
}

const openStoryCreator = function() {
  StorylyMoments.openStoryCreator()
}

interface MomentsStory {
  id: string
  title: string
  seen: boolean
  media: {
    type: string,
    actionUrl?: string,
  }
}

interface MomentsStoryGroup {
  id: string,
  iconUrl: string
  seen: boolean,
  stories: MomentsStory[]
}

enum Events {
  storylyMomentsEvent = "storylyMomentsEvent",
  onOpenCreateStory = "onOpenCreateStory",
  onOpenMyStory = "onOpenMyStory",
  onUserStoriesLoaded = "onUserStoriesLoaded" ,
  onUserStoriesLoadFailed = "onUserStoriesLoadFailed",
}
type MomentsEventType = keyof typeof Events


interface StorylyMomentsEvent { 
  eventName: string
  storyGroup?: MomentsStoryGroup
  stories?: MomentsStory[]
}
interface OpenCreateStoryEvent { 
  isDirectMediaUploaded: boolean
}
interface OpenMyStoryEvent {}
interface UserStoriesLoadedEvent { 
  storyGroup: MomentsStoryGroup
}
interface UserStoriesLoadFailedEvent { 
  errorMessage: string
}

type MomentsEvents = (event: StorylyMomentsEvent | OpenCreateStoryEvent | OpenMyStoryEvent | UserStoriesLoadedEvent | UserStoriesLoadFailedEvent) => void

const _eventEmitter = new NativeEventEmitter(StorylyMoments)
const _eventsSubscriptions = new Map<MomentsEvents, EmitterSubscription>()

const addEventListener = (event: MomentsEventType, handler: MomentsEvents) => {
  let isValidEventType = Object.keys(Events).includes(event)
  if (isValidEventType) {
    let listener = _eventEmitter.addListener(event, handler)
    _eventsSubscriptions.set(handler, listener)
    return {
      remove: () => removeEventListener(handler),
    }
  } else {
    console.warn(`Trying to subscribe to unknown event: "${event}"`)
    return {
      remove: () => {},
    }
  }
}

const setupInitialListeners = () => {
  Object.keys(Events).forEach((value: string) => {
    _eventEmitter.addListener(value, (_) => {})
  })
}


const removeEventListener = (handler: MomentsEvents) => {
  const listener = _eventsSubscriptions.get(handler)
  if (!listener) {
    return
  }
  listener.remove()
  _eventsSubscriptions.delete(handler)
}

const removeAllListeners = () => {
  _eventsSubscriptions.forEach((listener, key, map) => {
    listener.remove()
    map.delete(key)
  })
}

setupInitialListeners()

export default {
  ...StorylyMoments,
  initialize,
  openUserStories,
  openStoryCreator,
  addEventListener,
  removeAllListeners,
}
