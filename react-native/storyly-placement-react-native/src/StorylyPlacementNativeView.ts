import type { BaseEvent } from './data/util';


const isFabricEnabled = (global as any)?.nativeFabricUIManager != null;

export const applyBaseEvent = (callback: (event: BaseEvent) => void) => {
  const responseCallback = (event: any) => {
    if (event.nativeEvent.raw) {
      callback(JSON.parse(event.nativeEvent.raw) as BaseEvent);
    } else {
      callback({} as BaseEvent);
    }
  };
  return responseCallback;
};

const loadComponent = () => {
  if (isFabricEnabled) {
    const newarchComponent = require('./newarch/StorylyPlacementReactNativeViewNativeComponent');
    return {
      default: newarchComponent.default,
      PlacementCommands: newarchComponent.Commands,
    };
  } else {
    const oldarchComponent = require('./oldarch/StorylyPlacementReactNativeView');
    return {
      default: oldarchComponent.default,
      PlacementCommands: oldarchComponent.PlacementCommands,
    };
  }
};

const NativeViewModule = loadComponent();

export const PlacementCommands = NativeViewModule.PlacementCommands;
export default NativeViewModule.default;
