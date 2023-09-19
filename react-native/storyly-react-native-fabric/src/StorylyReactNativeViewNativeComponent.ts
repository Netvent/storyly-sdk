import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { HostComponent, NativeSyntheticEvent, ViewProps } from 'react-native';
import type { StoryInteractiveEvent, ProductEvent, StoryEvent, StoryLoadEvent, StoryPressEvent, StoryProductCartUpdateEvent, StoryProductHydrationEvent, StoryFailEvent, StoryPresentFail } from './data/event';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';
import type { STRCart, STRProductItem } from './data/story';
import type { StorylyConfig } from './data/config';


interface StorylyNativeProps extends ViewProps {
  storylyConfig: StorylyConfig;

  onStorylyLoaded?: (event: NativeSyntheticEvent<StoryLoadEvent>) => void;
  onStorylyLoadFailed?: (event: NativeSyntheticEvent<StoryFailEvent>) => void;
  onStorylyEvent?: (event: NativeSyntheticEvent<StoryEvent>) => void;
  onStorylyStoryPresented?: () => void;
  onStorylyStoryPresentFailed?: (event: NativeSyntheticEvent<StoryPresentFail>) => void;
  onStorylyStoryClose?: () => void;
  onStorylyActionClicked?: (event: NativeSyntheticEvent<StoryPressEvent>) => void;
  onStorylyUserInteracted?: (event: NativeSyntheticEvent<StoryInteractiveEvent>) => void;
  onStorylyProductHydration?: (event: NativeSyntheticEvent<StoryProductHydrationEvent>) => void;
  onStorylyCartUpdated?: (event: NativeSyntheticEvent<StoryProductCartUpdateEvent>) => void;
  onStorylyProductEvent?: (event: NativeSyntheticEvent<ProductEvent>) => void;
}

export const StorylyNativeView = codegenNativeComponent<StorylyNativeProps>('StorylyReactNativeView');

type StorylyComponentType = HostComponent<StorylyNativeProps>;
type StorylyComponentRef=  React.ElementRef<StorylyComponentType>

interface NativeCommands {
  open: (viewRef: StorylyComponentRef) => void;
  resumeStory: (viewRef: StorylyComponentRef) => void;
  pauseStory: (viewRef: StorylyComponentRef) => void;
  closeStory: (viewRef: StorylyComponentRef) => void;
  close: (viewRef: StorylyComponentRef) => void;
  openStory: (viewRef: StorylyComponentRef, uri: string) => void;
  openStoryWithId: (viewRef: StorylyComponentRef, groupId: string, storyId: String) => void;
  hydrateProducts: (viewRef: StorylyComponentRef, products: [STRProductItem]) => void;
  updateCart: (viewRef: StorylyComponentRef, cart: STRCart) => void;
  approveCartChange: (viewRef: StorylyComponentRef, responseId: string, cart: STRCart) => void;
  rejectCartChange: (viewRef: StorylyComponentRef, responseId: string, faileMsg: string) => void;
}

export const StorylyNativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: [
    "open",
    "resumeStory",
    "pauseStory",
    "closeStory",
    "close",
    "openStory",
    "openStoryWithId",
    "hydrateProducts",
    "updateCart",
    "approveCartChange",
    "rejectCartChange",
  ],
});
