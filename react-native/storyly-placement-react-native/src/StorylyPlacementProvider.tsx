/**
 * Storyly Placement - Provider Module
 * Non-view module for PlacementDataProvider implementation
 */

import { useEffect, useRef, useState } from 'react';
import { NativeEventEmitter } from 'react-native';
import type {
  PlacementHydrationEvent,
  PlacementLoadEvent,
  PlacementLoadFailEvent,
  StorylyPlacementConfig,
  STRCart,
  STRProductItem,
} from './data';
import StorylyPlacementProviderNative from './StorylyPlacementProviderNative';

export interface StorylyPlacementProviderListener {
  onLoad?: (event: PlacementLoadEvent) => void;
  onLoadFail?: (event: PlacementLoadFailEvent) => void;
  onHydration?: (event: PlacementHydrationEvent) => void;
}

export interface StorylyPlacementProvider {
  providerId: string | null;
  hydrateProducts: (products: STRProductItem[]) => void;
  hydrateWishlist: (products: STRProductItem[]) => void;
  updateCart: (cart: STRCart) => void;
  approveCartChange: (responseId: string, cart?: STRCart) => void;
  rejectCartChange: (responseId: string, failMessage: string) => void;
  approveWishlistChange: (responseId: string, item?: STRProductItem) => void;
  rejectWishlistChange: (responseId: string, failMessage: string) => void;
  destroy: () => void;
}

let eventEmitter: NativeEventEmitter | null = null;

const getEventEmitter = (): NativeEventEmitter => {
  if (!eventEmitter) {
    eventEmitter = new NativeEventEmitter(StorylyPlacementProviderNative as any);
  }
  return eventEmitter;
};

let providerIdCounter = 0;

const generateProviderId = (): string => {
  providerIdCounter += 1;
  return `provider_${providerIdCounter}_${Date.now()}`;
};

const setupEventListeners = (
  providerId: string,
  callbacks?: StorylyPlacementProviderListener
): Array<{ remove: () => void }> => {
  const emitter = getEventEmitter();
  const subscriptions: Array<{ remove: () => void }> = [];

  if (callbacks?.onLoad) {
    subscriptions.push(
      emitter.addListener(`${providerId}_onLoad`, (data: unknown) => {
        callbacks.onLoad?.(data as PlacementLoadEvent);
      })
    );
  }

  if (callbacks?.onLoadFail) {
    subscriptions.push(
      emitter.addListener(`${providerId}_onLoadFail`, (data: unknown) => {
        callbacks.onLoadFail?.(data as PlacementLoadFailEvent);
      })
    );
  }

  if (callbacks?.onHydration) {
    subscriptions.push(
      emitter.addListener(`${providerId}_onHydration`, (data: unknown) => {
        callbacks.onHydration?.(data as PlacementHydrationEvent);
      })
    );
  }

  return subscriptions;
};


export const useStorylyPlacementProvider = (
  config: StorylyPlacementConfig,
  listener?: StorylyPlacementProviderListener
): StorylyPlacementProvider => {
  const providerIdRef = useRef<string>(generateProviderId());
  var [providerId, setProviderId] = useState<string | null>(null);

  
  useEffect(() => {
    const currentProviderId = providerIdRef.current;
    console.debug('Creating provider with id:', currentProviderId);
    const result = StorylyPlacementProviderNative.createProvider(currentProviderId);
    
    if (result instanceof Promise) {
      result.then(() => {
        setProviderId(currentProviderId);
      });
    } else {
      setProviderId(currentProviderId);
    }

    return () => {
      StorylyPlacementProviderNative.destroyProvider(currentProviderId);
    };
  }, [providerIdRef.current]);

  useEffect(() => {
    if (!providerId) return;

    console.debug('Creating provider id', providerId,'with config:', config);
    const configJson = JSON.stringify(config);

    StorylyPlacementProviderNative.updateConfig(providerId, configJson);
  }, [providerId, config]);


  useEffect(() => {
    if (!providerId) return;

    const subscriptions = setupEventListeners(providerId, listener);
    return () => {
      subscriptions.forEach((sub) => sub.remove());
    };
  }, [providerId, listener]);


  return {
    providerId,
    hydrateProducts: (products: STRProductItem[]) => {
      StorylyPlacementProviderNative.hydrateProducts(
        providerId,
        JSON.stringify({ products })
      );
    },
    hydrateWishlist: (products: STRProductItem[]) => {
      StorylyPlacementProviderNative.hydrateWishlist(
        providerId,
        JSON.stringify({ products })
      );
    },
    updateCart: (cart: STRCart) => {
      StorylyPlacementProviderNative.updateCart(
        providerId,
        JSON.stringify({ cart })
      );
    },
    approveCartChange: (responseId: string, cart?: STRCart) => {
      StorylyPlacementProviderNative.approveCartChange(
        providerId,
        responseId,
        JSON.stringify({ cart })
      );
    },
    rejectCartChange: (responseId: string, failMessage: string) => {
      StorylyPlacementProviderNative.rejectCartChange(providerId, responseId, failMessage);
    },
    approveWishlistChange: (responseId: string, item?: STRProductItem) => {
      StorylyPlacementProviderNative.approveWishlistChange(
        providerId,
        responseId,
        JSON.stringify({ item })
      );
    },
    rejectWishlistChange: (responseId: string, failMessage: string) => {
      StorylyPlacementProviderNative.rejectWishlistChange(providerId, responseId, failMessage);
    },
    destroy: () => {
      StorylyPlacementProviderNative.destroyProvider(providerId);
    },
  };
};