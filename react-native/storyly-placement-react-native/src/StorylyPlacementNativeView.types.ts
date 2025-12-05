import type { ViewProps, HostComponent } from 'react-native';

import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypesNamespace';

export type NativeEvent = Readonly<{
  raw?: string;
}>;

export interface StorylyPlacementViewNativeProps extends ViewProps {
  providerId: string;

  // Widget Events
  onWidgetReady?: BubblingEventHandler<NativeEvent>;
  onActionClicked?: BubblingEventHandler<NativeEvent>;
  onEvent?: BubblingEventHandler<NativeEvent>;
  onFail?: BubblingEventHandler<NativeEvent>;

  // Product Events
  onProductEvent?: BubblingEventHandler<NativeEvent>;
  onUpdateCart?: BubblingEventHandler<NativeEvent>;
  onUpdateWishlist?: BubblingEventHandler<NativeEvent>;
}

export type StorylyPlacementViewComponentType = HostComponent<StorylyPlacementViewNativeProps>;

export const STORYLY_PLACEMENT_COMMANDS = [
  'approveCartChange',
  'rejectCartChange',
  'approveWishlistChange',
  'rejectWishlistChange',
] as const;

export interface NativeCommands {
  approveCartChange: (viewRef: React.ComponentRef<StorylyPlacementViewComponentType>, raw: string) => void;
  rejectCartChange: (viewRef: React.ComponentRef<StorylyPlacementViewComponentType>, raw: string) => void;

  approveWishlistChange: (viewRef: React.ComponentRef<StorylyPlacementViewComponentType>, raw: string) => void;
  rejectWishlistChange: (viewRef: React.ComponentRef<StorylyPlacementViewComponentType>, raw: string) => void;
}

