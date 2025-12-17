/**
 * Storyly Placement - Provider Module
 * Non-view module for PlacementDataProvider implementation
 */

import { useEffect, useRef, useState, useMemo } from 'react';
import { NativeEventEmitter } from 'react-native';
import type {
  PlacementHydrationEvent,
  PlacementLoadEvent,
  PlacementLoadFailEvent,
  StorylyPlacementConfig,
  STRCart,
  STRProductItem,
} from './data';
import StorylyPlacementProviderNative from './native/StorylyPlacementProviderNative';

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
    StorylyPlacementProviderNative.createProvider(currentProviderId).then(() => {
      setProviderId(currentProviderId);
    });

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

  return useMemo(() => ({
    providerId,
    hydrateProducts: (products: STRProductItem[]) => {
      if (!providerId) return;
      StorylyPlacementProviderNative.hydrateProducts(
        providerId,
        JSON.stringify({ products })
      );
    },
    hydrateWishlist: (products: STRProductItem[]) => {
      if (!providerId) return;
      StorylyPlacementProviderNative.hydrateWishlist(
        providerId,
        JSON.stringify({ products })
      );
    },
    updateCart: (cart: STRCart) => {
      if (!providerId) return;
      StorylyPlacementProviderNative.updateCart(
        providerId,
        JSON.stringify({ cart })
      );
    },
    destroy: () => {
      if (!providerId) return;
      StorylyPlacementProviderNative.destroyProvider(providerId);
    },
  }), [providerId]);
};