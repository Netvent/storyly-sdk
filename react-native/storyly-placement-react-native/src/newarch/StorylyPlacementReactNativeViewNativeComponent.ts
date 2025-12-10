/**
 * Storyly Placement - Native View Component Spec
 * New React Native architecture (Fabric) - uses codegen types
 */

import { type ViewProps, type HostComponent, codegenNativeComponent, codegenNativeCommands } from 'react-native';
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

export interface NativeCommands {
  approveCartChange: (viewRef: React.ElementRef<StorylyPlacementViewComponentType>, raw: string) => void;
  rejectCartChange: (viewRef: React.ElementRef<StorylyPlacementViewComponentType>, raw: string) => void;

  approveWishlistChange: (viewRef: React.ElementRef<StorylyPlacementViewComponentType>, raw: string) => void;
  rejectWishlistChange: (viewRef: React.ElementRef<StorylyPlacementViewComponentType>, raw: string) => void;
}

export const STORYLY_PLACEMENT_COMMANDS = [
  'approveCartChange',
  'rejectCartChange',
  'approveWishlistChange',
  'rejectWishlistChange',
] as const;


export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: [
    'approveCartChange',
    'rejectCartChange',
    'approveWishlistChange',
    'rejectWishlistChange',
  ],
});

export const PlacementCommands = Commands;

export default codegenNativeComponent<StorylyPlacementViewNativeProps>(
  'StorylyPlacementReactNativeView'
) as StorylyPlacementViewComponentType;