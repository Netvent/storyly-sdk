import type { HostComponent } from 'react-native';
import type { BaseEvent } from './data/event';
import type { NativeCommands, NativeEvent, StorylyPlacementViewNativeProps } from './newarch/StorylyPlacementReactNativeViewNativeComponent';
import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypesNamespace';


const isFabricEnabled = (global as any)?.nativeFabricUIManager != null;

export const applyBaseEvent = (callback: (event: BaseEvent) => void) => {
  const responseCallback: BubblingEventHandler<NativeEvent> = (event) => {
    console.log(event.nativeEvent.raw)
    if (event.nativeEvent.raw) {
      callback(JSON.parse(event.nativeEvent.raw) as BaseEvent);
    } else {
      callback({} as BaseEvent);
    }
  };
  return responseCallback;
};


const NativeViewModule = (isFabricEnabled
  ? require('./newarch/StorylyPlacementReactNativeViewNativeComponent')
  : require('./oldarch/StorylyPlacementReactNativeView')) as {
    default: HostComponent<StorylyPlacementViewNativeProps>;
    PlacementCommands: NativeCommands;
  };

export const PlacementCommands = NativeViewModule.PlacementCommands;

export default NativeViewModule.default;
