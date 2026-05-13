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
  StorylyPlacementConfig,
  STRProductInformation,
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
  callbacks?: StorylyPlacementProviderListener
): Array<{ remove: () => void }> => {
  const emitter = getEventEmitter();
  const subscriptions: Array<{ remove: () => void }> = [];

  if (callbacks?.onLoad) {
    subscriptions.push(
      emitter.addListener(`${providerId}_onLoad`, (data: unknown) => {
        try {
          const event = JSON.parse(data as string) as PlacementLoadEvent;
          callbacks.onLoad?.(event);
        } catch (error) {
          console.error('Error parsing onLoad event:', error);
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
        } catch (error) {
          console.error('Error parsing onLoadFail event:', error);
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
        } catch (error) {
          console.error('Error parsing onHydration event:', error);
        }
      })
    );
  }

  return subscriptions;
};


export const useStorylyPlacementProvider = (
  config: StorylyPlacementConfig,
  listener?: StorylyPlacementProviderListener
): StorylyPlacementProvider => {
  const configJson = useMemo(() => JSON.stringify(config), [config]);

  const [provider, setProvider] = useState<StorylyPlacementProvider>({
    providerId: null,
    hydrateProducts: () => {},
    hydrateWishlist: () => {},
    destroy: () => {},
  });

  const createProviderInstance = (pid: string): StorylyPlacementProvider => ({
      providerId: pid,
      hydrateProducts: (products: STRProductItem[]) => {
        console.debug('Hydrating products for provider id', pid,'with products:', products);
        StorylyPlacementProviderNative.hydrateProducts(
          pid,
          JSON.stringify({ products })
        );
      },
      hydrateWishlist: (products: STRProductInformation[]) => {
        console.debug('Hydrating wishlist for provider id', pid,'with products:', products);
        StorylyPlacementProviderNative.hydrateWishlist(
          pid,
          JSON.stringify({ products })
        );
      },
      destroy: () => {
        console.debug('Destroying provider id', pid);
        StorylyPlacementProviderNative.destroyProvider(pid);
      },
    });

  useEffect(() => {
    const currentProviderId = generateProviderId();
    console.debug('Creating provider with id:', currentProviderId);
    StorylyPlacementProviderNative.createProvider(currentProviderId).then(() => {
      setProvider(createProviderInstance(currentProviderId));
    })

    return () => {
      console.debug('Destroying provider with id:', currentProviderId);
      StorylyPlacementProviderNative.destroyProvider(currentProviderId);
    };
  }, []);

  useEffect(() => {
    if (!provider.providerId) return;
    console.debug('Updating config for provider id', provider.providerId,'with config:', configJson);
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
