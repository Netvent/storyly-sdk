import {
  requireNativeComponent,
  UIManager,
  findNodeHandle,
} from 'react-native';
import { type StorylyPlacementViewNativeProps } from '../newarch/StorylyPlacementReactNativeViewNativeComponent';


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

export interface NativeCommands {
  callWidget: (viewRef: any, id: string, method: string, raw: string) => void;

  approveCartChange: (viewRef: any, responseId: string, raw: string) => void;
  rejectCartChange: (viewRef: any, responseId: string, raw: string) => void;

  approveWishlistChange: (viewRef: any, responseId: string, raw: string) => void;
  rejectWishlistChange: (viewRef: any, responseId: string, raw: string) => void;
}

export const PlacementCommands: NativeCommands = {
  approveCartChange: (view: any, responseId: string, raw: string) => {
    dispatchCommand(view, 'approveCartChange', [responseId, raw]);
  },
  rejectCartChange: (view: any, responseId: string, raw: string) => {
    dispatchCommand(view, 'rejectCartChange', [responseId, raw]);
  },
  approveWishlistChange: (view: any, responseId: string, raw: string) => {
    dispatchCommand(view, 'approveWishlistChange', [responseId, raw]);
  },
  rejectWishlistChange: (view: any, responseId: string, raw: string) => {
    dispatchCommand(view, 'rejectWishlistChange', [responseId, raw]);
  },
  callWidget: (view: any, id: string, method: string, raw: string | null) => {
    dispatchCommand(view, 'callWidget', [id, method, raw]);
  },
};


const StorylyPlacementNativeView =
  requireNativeComponent<StorylyPlacementViewNativeProps>(COMPONENT_NAME);

export default StorylyPlacementNativeView;
