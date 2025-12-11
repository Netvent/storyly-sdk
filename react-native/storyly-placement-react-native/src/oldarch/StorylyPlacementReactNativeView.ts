import {
  requireNativeComponent,
  UIManager,
  findNodeHandle,
} from 'react-native';
import { STORYLY_PLACEMENT_COMMANDS, type NativeCommands, type StorylyPlacementViewNativeProps } from '../newarch/StorylyPlacementReactNativeViewNativeComponent';


const COMPONENT_NAME = 'StorylyPlacementReactNativeViewLegacy';

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

const PlacementCommands: NativeCommands = {} as NativeCommands;

STORYLY_PLACEMENT_COMMANDS.forEach((command) => {
  (PlacementCommands as any)[command] = (view: any, raw: string) => {
    dispatchCommand(view, command, [raw]);
  };
});

export { PlacementCommands };

const StorylyPlacementNativeView =
  requireNativeComponent<StorylyPlacementViewNativeProps>(COMPONENT_NAME);

export default StorylyPlacementNativeView;
