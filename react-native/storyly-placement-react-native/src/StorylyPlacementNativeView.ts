import type { HostComponent } from 'react-native';
import type { BaseEvent } from './data/event';
import type { 
  StorylyPlacementViewNativeProps, 
  NativeCommands,
  NativeEvent,
  BubblingEventHandler,
} from './StorylyPlacementNativeView.types';

const isFabricEnabled = (global as any)?.nativeFabricUIManager != null;

const NativeViewModule = (isFabricEnabled
  ? require('./newarch/StorylyPlacementReactNativeViewNativeComponent')
  : require('./oldarch/StorylyPlacementReactNativeView')) as {
    default: HostComponent<StorylyPlacementViewNativeProps>;
    Commands: NativeCommands;
    applyBaseEvent: (callback: (event: BaseEvent) => void) => BubblingEventHandler<NativeEvent>;
  };

export const Commands = NativeViewModule.Commands;
export const applyBaseEvent = NativeViewModule.applyBaseEvent;

export default NativeViewModule.default;
