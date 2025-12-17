
import { forwardRef, useImperativeHandle, useRef } from 'react';
import type { ViewProps } from 'react-native';
import type {
  STRCart,
  BaseEvent,
  PlacementActionClickEvent,
  PlacementCartUpdateEvent,
  PlacementEvent,
  PlacementFailEvent,
  PlacementProductEvent,
  PlacementWidgetReadyEvent,
  PlacementWishlistUpdateEvent,
  PlacementWidget,
 } from './data';
import StorylyPlacementNativeView, { PlacementCommands, applyBaseEvent } from './native/StorylyPlacementNativeView';
import type { StorylyPlacementProvider } from './StorylyPlacementProvider';
import { createWidgetProxy, type STRWidgetController } from './StorylyWidget';


type StorylyPlacementNativeComponentRef = React.ComponentRef<typeof StorylyPlacementNativeView>;

export interface StorylyPlacementProps extends ViewProps {
  provider?: StorylyPlacementProvider;

  onWidgetReady?: (event: PlacementWidgetReadyEvent) => void;
  onActionClicked?: (event: PlacementActionClickEvent) => void;
  onEvent?: (event: PlacementEvent) => void;
  onFail?: (event: PlacementFailEvent) => void;
  onProductEvent?: (event: PlacementProductEvent) => void;
  onUpdateCart?: (event: PlacementCartUpdateEvent) => void;
  onUpdateWishlist?: (event: PlacementWishlistUpdateEvent) => void;
}


export interface StorylyPlacementMethods {
  getWidget<T extends STRWidgetController>(widget: PlacementWidget): T;
  approveCartChange: (responseId: string, cart: STRCart) => void;
  rejectCartChange: (responseId: string, failMessage: string) => void;
  approveWishlistChange: (responseId: string, item: STRCart) => void;
  rejectWishlistChange: (responseId: string, failMessage: string) => void;
}

     
const StorylyPlacement = forwardRef<StorylyPlacementMethods, StorylyPlacementProps>(
  (props, ref) => {
    const placementRef = useRef<StorylyPlacementNativeComponentRef>(null);

    const getWidget = <T extends STRWidgetController>(widget: PlacementWidget): T => {
      return createWidgetProxy(widget, (method: string, params: any) => {
        if (placementRef.current) {
          console.log('callWidget', widget.viewId, method, JSON.stringify(params));
          PlacementCommands.callWidget(placementRef.current, widget.viewId, method, JSON.stringify(params));
        }
      }) as T;
    };

    const approveCartChange = (responseId: string, cart: STRCart) => {
      if (placementRef.current) {
        PlacementCommands.approveCartChange(placementRef.current, responseId, JSON.stringify({ cart }));
      }
    };

    const rejectCartChange = (responseId: string, failMessage: string) => {
      if (placementRef.current) {
        PlacementCommands.rejectCartChange(placementRef.current, responseId, JSON.stringify({ failMessage }));
      }
    };

    const approveWishlistChange = (responseId: string, item: STRCart) => {
      if (placementRef.current) {
        PlacementCommands.approveWishlistChange(placementRef.current, responseId, JSON.stringify({ item }));
      }
    };

    const rejectWishlistChange = (responseId: string, failMessage: string) => {
      if (placementRef.current) {
        PlacementCommands.rejectWishlistChange(placementRef.current, responseId, JSON.stringify({ failMessage }));
      }
    };

    useImperativeHandle(ref, () => ({
      getWidget,
      approveCartChange,
      rejectCartChange,
      approveWishlistChange,
      rejectWishlistChange,
    }));

    const _onWidgetReady = applyBaseEvent((event: BaseEvent) => {
      if (props.onWidgetReady) {
        props.onWidgetReady(event as PlacementWidgetReadyEvent);
      }
    });

    const _onActionClicked = applyBaseEvent((event: BaseEvent) => {
      if (props.onActionClicked) {
        props.onActionClicked(event as PlacementActionClickEvent);
      }
    });

    const _onEvent = applyBaseEvent((event: BaseEvent) => {
      if (props.onEvent) {
        props.onEvent(event as PlacementEvent);
      }
    });

    const _onFail = applyBaseEvent((event: BaseEvent) => {
      if (props.onFail) {
        props.onFail(event as PlacementFailEvent);
      }
    });

    const _onProductEvent = applyBaseEvent((event: BaseEvent) => {
      if (props.onProductEvent) {
        props.onProductEvent(event as PlacementProductEvent);
      }
    });

    const _onUpdateCart = applyBaseEvent((event: BaseEvent) => {
      if (props.onUpdateCart) {
        props.onUpdateCart(event as PlacementCartUpdateEvent);
      }
    });

    const _onUpdateWishlist = applyBaseEvent((event: BaseEvent) => {
      if (props.onUpdateWishlist) {
        props.onUpdateWishlist(event as PlacementWishlistUpdateEvent);
      }
    });

    return (
      <StorylyPlacementNativeView
        {...props}
        ref={placementRef}
        providerId={props.provider?.providerId ?? undefined}
        onWidgetReady={_onWidgetReady}
        onActionClicked={_onActionClicked}
        onEvent={_onEvent}
        onFail={_onFail}
        onProductEvent={_onProductEvent}
        onUpdateCart={_onUpdateCart}
        onUpdateWishlist={_onUpdateWishlist}
      />
    );
  }
);

export default StorylyPlacement;

