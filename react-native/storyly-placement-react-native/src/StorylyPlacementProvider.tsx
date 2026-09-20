/**
 * Storyly Placement - Provider Module
 * Non-view module for PlacementDataProvider implementation
 */

import { useEffect, useState, useMemo } from 'react';
import { NativeEventEmitter } from 'react-native';
import type {
  PlacementHydrationEvent,
  PlacementLoadEvent,
  PlacementLoadFailEvent,
  STRPlacementConfig,
  STRProductInformation,
  STRProductItem,
} from './data';
import StorylyPlacementProviderNative from './native/StorylyPlacementProviderNative';

export interface STRPlacementDataProviderListener {
  onLoad?: (event: PlacementLoadEvent) => void;
  onLoadFail?: (event: PlacementLoadFailEvent) => void;
  onHydration?: (event: PlacementHydrationEvent) => void;
}

export interface STRPlacementDataProvider {
  providerId: string | null;
  hydrateProducts: (products: STRProductItem[]) => void;
  hydrateWishlist: (products: STRProductInformation[]) => void;
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
  callbacks?: STRPlacementDataProviderListener
): Array<{ remove: () => void }> => {
  const emitter = getEventEmitter();
  const subscriptions: Array<{ remove: () => void }> = [];

  if (callbacks?.onLoad) {
    subscriptions.push(
      emitter.addListener(`${providerId}_onLoad`, (data: unknown) => {
        try {
          const event = JSON.parse(data as string) as PlacementLoadEvent;
          callbacks.onLoad?.(event);
        } catch {
          // malformed payload from native; ignored
        }
      })
    );
  }

  if (callbacks?.onLoadFail) {
    subscriptions.push(
      emitter.addListener(`${providerId}_onLoadFail`, (data: unknown) => {
        try {
          const event = JSON.parse(data as string) as PlacementLoadFailEvent;
          callbacks.onLoadFail?.(event);
        } catch {
          // malformed payload from native; ignored
        }
      })
    );
  }

  if (callbacks?.onHydration) {
    subscriptions.push(
      emitter.addListener(`${providerId}_onHydration`, (data: unknown) => {
        try {
          const event = JSON.parse(data as string) as PlacementHydrationEvent;
          callbacks.onHydration?.(event);
        } catch {
          // malformed payload from native; ignored
        }
      })
    );
  }

  return subscriptions;
};


export const useSTRPlacementDataProvider = (
  config: STRPlacementConfig,
  listener?: STRPlacementDataProviderListener
): STRPlacementDataProvider => {
  const configJson = useMemo(() => JSON.stringify(config), [config]);

  const [provider, setProvider] = useState<STRPlacementDataProvider>({
    providerId: null,
    hydrateProducts: () => {},
    hydrateWishlist: () => {},
    destroy: () => {},
  });

  const createProviderInstance = (pid: string): STRPlacementDataProvider => ({
      providerId: pid,
      hydrateProducts: (products: STRProductItem[]) => {
        StorylyPlacementProviderNative.hydrateProducts(
          pid,
          JSON.stringify({ products })
        );
      },
      hydrateWishlist: (products: STRProductInformation[]) => {
        StorylyPlacementProviderNative.hydrateWishlist(
          pid,
          JSON.stringify({ products })
        );
      },
      destroy: () => {
        StorylyPlacementProviderNative.destroyProvider(pid);
      },
    });

  useEffect(() => {
    const currentProviderId = generateProviderId();
    StorylyPlacementProviderNative.createProvider(currentProviderId).then(() => {
      setProvider(createProviderInstance(currentProviderId));
    })

    return () => {
      StorylyPlacementProviderNative.destroyProvider(currentProviderId);
    };
  }, []);

  useEffect(() => {
    if (!provider.providerId) return;
    StorylyPlacementProviderNative.updateConfig(provider.providerId, configJson);
  }, [provider.providerId, configJson]);


  useEffect(() => {
    if (!provider.providerId) return;

    const subscriptions = setupEventListeners(provider.providerId, listener);
    return () => {
      subscriptions.forEach((sub) => sub.remove());
    };
  }, [provider.providerId, listener]);

  return provider;
};
