import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { HostComponent, ViewProps } from 'react-native';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';
import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';
import type { BaseEvent } from '../data/event';

type Event = Readonly<{
  raw?: string;
}>;

interface StorylyNativeProps extends ViewProps {
  storylyConfig: string;

  onStorylyLoaded: BubblingEventHandler<Event>;
  onStorylyLoadFailed: BubblingEventHandler<Event>;
  onStorylyEvent: BubblingEventHandler<Event>;
  onStorylyStoryPresented: BubblingEventHandler<Event>;
  onStorylyStoryPresentFailed: BubblingEventHandler<Event>;
  onStorylyStoryClose: BubblingEventHandler<Event>;
  onStorylyActionClicked: BubblingEventHandler<Event>;
  onStorylyUserInteracted: BubblingEventHandler<Event>;
  onStorylyProductHydration: BubblingEventHandler<Event>;
  onStorylyCartUpdated: BubblingEventHandler<Event>;
  onStorylyProductEvent: BubblingEventHandler<Event>;
}

export const applyBaseEvent = (callback: (event: BaseEvent)=>void) => {
  let responseCallback: BubblingEventHandler<Event> = (event) => {
      if (event.nativeEvent.raw) {
        callback(JSON.parse(event.nativeEvent.raw) as BaseEvent);
      } else {
        callback({} as BaseEvent);
      }
  };
  return responseCallback;
}

type StorylyComponentType = HostComponent<StorylyNativeProps>;

interface NativeCommands {
  resumeStory: (viewRef: React.ElementRef<StorylyComponentType>) => void;
  pauseStory: (viewRef: React.ElementRef<StorylyComponentType>) => void;
  closeStory: (viewRef: React.ElementRef<StorylyComponentType>) => void;
  openStory: (viewRef: React.ElementRef<StorylyComponentType>, raw: string) => void;
  openStoryWithId: (viewRef: React.ElementRef<StorylyComponentType>, raw: string) => void;
  hydrateProducts: (viewRef: React.ElementRef<StorylyComponentType>, raw: string) => void;
  updateCart: (viewRef: React.ElementRef<StorylyComponentType>, raw: string) => void;
  approveCartChange: (viewRef: React.ElementRef<StorylyComponentType>, raw: string) => void;
  rejectCartChange: (viewRef: React.ElementRef<StorylyComponentType>, raw: string) => void;
}

export const StorylyNativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: [
    "resumeStory",
    "pauseStory",
    "closeStory",
    "openStory",
    "openStoryWithId",
    "hydrateProducts",
    "updateCart",
    "approveCartChange",
    "rejectCartChange",
  ],
});

export default codegenNativeComponent<StorylyNativeProps>("StorylyReactNativeView") as HostComponent<StorylyNativeProps>;