
import { forwardRef, useImperativeHandle, useRef } from 'react';
import type { ViewProps } from 'react-native';
import type {
  BaseEvent,
  PlacementActionEvent,
  PlacementCartUpdateEvent,
  PlacementFailEvent,
  PlacementProductEvent,
  PlacementWidgetEvent,
  PlacementWidgetReadyEvent,
  PlacementWishlistUpdateEvent,
} from './data/event';
import type { STRCart } from './data/story';
import StorylyPlacementNativeView, { PlacementCommands, applyBaseEvent } from './StorylyPlacementNativeView';
import type { StorylyPlacementProvider } from './StorylyPlacementProvider';


type StorylyPlacementNativeComponentRef = React.ComponentRef<typeof StorylyPlacementNativeView>;

export interface StorylyPlacementProps extends ViewProps {
  provider?: StorylyPlacementProvider;

  onWidgetReady?: (event: PlacementWidgetReadyEvent) => void;
  onActionClicked?: (event: PlacementActionEvent) => void;
  onEvent?: (event: PlacementWidgetEvent) => void;
  onFail?: (event: PlacementFailEvent) => void;
  onProductEvent?: (event: PlacementProductEvent) => void;
  onUpdateCart?: (event: PlacementCartUpdateEvent) => void;
  onUpdateWishlist?: (event: PlacementWishlistUpdateEvent) => void;
}

export interface StorylyPlacementMethods {
  approveCartChange: (responseId: string, cart: STRCart) => void;
  rejectCartChange: (responseId: string, failMessage: string) => void;
  approveWishlistChange: (responseId: string, item: STRCart) => void;
  rejectWishlistChange: (responseId: string, failMessage: string) => void;
}

const StorylyPlacement = forwardRef<StorylyPlacementMethods, StorylyPlacementProps>(
  (props, ref) => {
    const placementRef = useRef<StorylyPlacementNativeComponentRef>(null);

    const approveCartChange = (responseId: string, cart: STRCart) => {
      if (placementRef.current) {
        PlacementCommands.approveCartChange(placementRef.current, JSON.stringify({ responseId, cart }));
      }
    };

    const rejectCartChange = (responseId: string, failMessage: string) => {
      if (placementRef.current) {
        PlacementCommands.rejectCartChange(placementRef.current, JSON.stringify({ responseId, failMessage }));
      }
    };

    const approveWishlistChange = (responseId: string, item: STRCart) => {
      if (placementRef.current) {
        PlacementCommands.approveWishlistChange(placementRef.current, JSON.stringify({ responseId, item }));
      }
    };

    const rejectWishlistChange = (responseId: string, failMessage: string) => {
      if (placementRef.current) {
        PlacementCommands.rejectWishlistChange(placementRef.current, JSON.stringify({ responseId, failMessage }));
      }
    };

    useImperativeHandle(ref, () => ({
      approveCartChange,
      rejectCartChange,
      approveWishlistChange,
      rejectWishlistChange,
    }));

    const _onWidgetReady = (event: BaseEvent) => {
      if (props.onWidgetReady) {
        props.onWidgetReady(event as PlacementWidgetReadyEvent);
      }
    };

    const _onActionClicked = (event: BaseEvent) => {
      if (props.onActionClicked) {
        props.onActionClicked(event as PlacementActionEvent);
      }
    };

    const _onEvent = (event: BaseEvent) => {
      if (props.onEvent) {
        props.onEvent(event as PlacementWidgetEvent);
      }
    };

    const _onFail = (event: BaseEvent) => {
      if (props.onFail) {
        props.onFail(event as PlacementFailEvent);
      }
    };

    const _onProductEvent = (event: BaseEvent) => {
      if (props.onProductEvent) {
        props.onProductEvent(event as PlacementProductEvent);
      }
    };

    const _onUpdateCart = (event: BaseEvent) => {
      if (props.onUpdateCart) {
        props.onUpdateCart(event as PlacementCartUpdateEvent);
      }
    };

    const _onUpdateWishlist = (event: BaseEvent) => {
      if (props.onUpdateWishlist) {
        props.onUpdateWishlist(event as PlacementWishlistUpdateEvent);
      }
    };

    return (
      <StorylyPlacementNativeView
        {...props}
        ref={placementRef}
        providerId={props.provider?.providerId ?? ''}
        onWidgetReady={applyBaseEvent(_onWidgetReady)}
        onActionClicked={applyBaseEvent(_onActionClicked)}
        onEvent={applyBaseEvent(_onEvent)}
        onFail={applyBaseEvent(_onFail)}
        onProductEvent={applyBaseEvent(_onProductEvent)}
        onUpdateCart={applyBaseEvent(_onUpdateCart)}
        onUpdateWishlist={applyBaseEvent(_onUpdateWishlist)}
      />
    );
  }
);

export default StorylyPlacement;

