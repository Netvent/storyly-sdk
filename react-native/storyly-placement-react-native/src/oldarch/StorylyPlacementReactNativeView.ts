import {
  requireNativeComponent,
  UIManager,
  findNodeHandle,
} from 'react-native';
import type { BaseEvent } from '../data/event';
import type { 
  StorylyPlacementViewNativeProps, 
  NativeCommands,
  NativeEvent,
  BubblingEventHandler
} from '../StorylyPlacementNativeView.types';
import { STORYLY_PLACEMENT_COMMANDS } from '../StorylyPlacementNativeView.types';

export const applyBaseEvent = (callback: (event: BaseEvent) => void) => {
  const responseCallback: BubblingEventHandler<NativeEvent> = (event) => {
    if (event.nativeEvent.raw) {
      callback(JSON.parse(event.nativeEvent.raw) as BaseEvent);
    } else {
      callback({} as BaseEvent);
    }
  };
  return responseCallback;
};

const COMPONENT_NAME = 'StorylyPlacementReactNativeView';

const dispatchCommand = (
  view: any,
  commandName: string,
  args: any[] = []
) => {
  const handle = findNodeHandle(view);
  if (handle != null) {
    const viewConfig = UIManager.getViewManagerConfig(COMPONENT_NAME) as any;
    const commands = viewConfig?.Commands;
    const commandId = commands?.[commandName];
    if (commandId != null) {
      UIManager.dispatchViewManagerCommand(handle, commandId, args);
    }
  }
};

const Commands: NativeCommands = {} as NativeCommands;

STORYLY_PLACEMENT_COMMANDS.forEach((command) => {
  (Commands as any)[command] = (view: any, raw: string) => {
    dispatchCommand(view, command, [raw]);
  };
});

export { Commands };

const StorylyPlacementNativeView =
  requireNativeComponent<StorylyPlacementViewNativeProps>(COMPONENT_NAME);

export default StorylyPlacementNativeView;
