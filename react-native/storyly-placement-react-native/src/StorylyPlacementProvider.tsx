/**
 * Storyly Placement - Provider Module
 * Non-view module for PlacementDataProvider implementation
 */

import { useCallback, useEffect, useRef } from 'react';
import { NativeEventEmitter, NativeModules, Platform } from 'react-native';
import type {
  STRCart,
  STRProductItem,
} from './data/story';
import type {
  PlacementHydrationEvent,
  PlacementLoadEvent,
  PlacementLoadFailEvent,
} from './data/event';
import type { StorylyPlacementConfig } from './data/config';

// MARK: - Native Module Access

const LINKING_ERROR =
  `The package 'storyly-placement-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

// Get the native module with TurboModule support
const StorylyPlacementProviderModule = (() => {
  // Try to get TurboModule first (new arch)
  try {
    return require('./newarch/NativeStorylyPlacementProvider').default;
  } catch {
    // Fall back to legacy module
    return NativeModules.StorylyPlacementProvider;
  }
})();

const StorylyPlacementProvider = StorylyPlacementProviderModule
  ? StorylyPlacementProviderModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export interface StorylyPlacementProviderCallbacks {
  onLoad?: (event: PlacementLoadEvent) => void;
  onLoadFail?: (event: PlacementLoadFailEvent) => void;
  onHydration?: (event: PlacementHydrationEvent) => void;
}

export interface StorylyPlacementProviderMethods {
  hydrateProducts: (products: STRProductItem[]) => void;
  hydrateWishlist: (products: STRProductItem[]) => void;
  updateCart: (cart: STRCart) => void;
  approveCartChange: (responseId: string, cart?: STRCart) => void;
  rejectCartChange: (responseId: string, failMessage: string) => void;
  approveWishlistChange: (responseId: string, item?: STRProductItem) => void;
  rejectWishlistChange: (responseId: string, failMessage: string) => void;
  destroy: () => void;
}

// MARK: - Event Emitter

let eventEmitter: NativeEventEmitter | null = null;

const getEventEmitter = (): NativeEventEmitter => {
  if (!eventEmitter) {
    eventEmitter = new NativeEventEmitter(StorylyPlacementProvider);
  }
  return eventEmitter;
};

// MARK: - Provider ID Generator

let providerIdCounter = 0;

const generateProviderId = (): string => {
  providerIdCounter += 1;
  return `provider_${providerIdCounter}_${Date.now()}`;
};

// MARK: - Hook: useStorylyPlacementProvider

export const useStorylyPlacementProvider = (
  config: StorylyPlacementConfig,
  callbacks?: StorylyPlacementProviderCallbacks
): StorylyPlacementProviderMethods & { providerId: string } => {
  const providerIdRef = useRef<string>(generateProviderId());
  const providerId = providerIdRef.current;

  // Initialize provider on mount
  useEffect(() => {
    const configJson = JSON.stringify({
      placementInit: {
        token: config.token,
        testMode: config.testMode,
        locale: config.locale,
        layoutDirection: config.layoutDirection,
        customParameter: config.customParameter,
        labels: config.labels,
        userProperties: config.userProperties,
      },
      productConfig: config.productConfig,
    });

    StorylyPlacementProvider.createProvider(providerId, configJson);

    return () => {
      StorylyPlacementProvider.destroyProvider(providerId);
    };
  }, [providerId, config.token]); // Only re-create on token change

  // Setup event listeners
  useEffect(() => {
    const emitter = getEventEmitter();
    const subscriptions: ReturnType<typeof emitter.addListener>[] = [];

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

    return () => {
      subscriptions.forEach((sub) => sub.remove());
    };
  }, [providerId, callbacks]);

  // Provider methods
  const hydrateProducts = useCallback(
    (products: STRProductItem[]) => {
      StorylyPlacementProvider.hydrateProducts(
        providerId,
        JSON.stringify({ products })
      );
    },
    [providerId]
  );

  const hydrateWishlist = useCallback(
    (products: STRProductItem[]) => {
      StorylyPlacementProvider.hydrateWishlist(
        providerId,
        JSON.stringify({ products })
      );
    },
    [providerId]
  );

  const updateCart = useCallback(
    (cart: STRCart) => {
      StorylyPlacementProvider.updateCart(providerId, JSON.stringify({ cart }));
    },
    [providerId]
  );

  const approveCartChange = useCallback(
    (responseId: string, cart?: STRCart) => {
      StorylyPlacementProvider.approveCartChange(
        providerId,
        responseId,
        JSON.stringify({ cart })
      );
    },
    [providerId]
  );

  const rejectCartChange = useCallback(
    (responseId: string, failMessage: string) => {
      StorylyPlacementProvider.rejectCartChange(providerId, responseId, failMessage);
    },
    [providerId]
  );

  const approveWishlistChange = useCallback(
    (responseId: string, item?: STRProductItem) => {
      StorylyPlacementProvider.approveWishlistChange(
        providerId,
        responseId,
        JSON.stringify({ item })
      );
    },
    [providerId]
  );

  const rejectWishlistChange = useCallback(
    (responseId: string, failMessage: string) => {
      StorylyPlacementProvider.rejectWishlistChange(providerId, responseId, failMessage);
    },
    [providerId]
  );

  const destroy = useCallback(() => {
    StorylyPlacementProvider.destroyProvider(providerId);
  }, [providerId]);

  return {
    providerId,
    hydrateProducts,
    hydrateWishlist,
    updateCart,
    approveCartChange,
    rejectCartChange,
    approveWishlistChange,
    rejectWishlistChange,
    destroy,
  };
};

// MARK: - Class-based Provider (Alternative API)

export class PlacementDataProvider {
  private providerId: string;
  private callbacks: StorylyPlacementProviderCallbacks;
  private subscriptions: Array<{ remove: () => void }> = [];

  constructor(
    config: StorylyPlacementConfig,
    callbacks?: StorylyPlacementProviderCallbacks
  ) {
    this.providerId = generateProviderId();
    this.callbacks = callbacks || {};


    StorylyPlacementProvider.createProvider(this.providerId, JSON.stringify(config));
    this.setupEventListeners();
  }

  private setupEventListeners(): void {
    const emitter = getEventEmitter();

    if (this.callbacks.onLoad) {
      this.subscriptions.push(
        emitter.addListener(`${this.providerId}_onLoad`, (data: unknown) => {
          this.callbacks.onLoad?.(data as PlacementLoadEvent);
        })
      );
    }

    if (this.callbacks.onLoadFail) {
      this.subscriptions.push(
        emitter.addListener(`${this.providerId}_onLoadFail`, (data: unknown) => {
          this.callbacks.onLoadFail?.(data as PlacementLoadFailEvent);
        })
      );
    }

    if (this.callbacks.onHydration) {
      this.subscriptions.push(
        emitter.addListener(`${this.providerId}_onHydration`, (data: unknown) => {
          this.callbacks.onHydration?.(data as PlacementHydrationEvent);
        })
      );
    }
  }

  getId(): string {
    return this.providerId;
  }

  hydrateProducts(products: STRProductItem[]): void {
    StorylyPlacementProvider.hydrateProducts(
      this.providerId,
      JSON.stringify({ products })
    );
  }

  hydrateWishlist(products: STRProductItem[]): void {
    StorylyPlacementProvider.hydrateWishlist(
      this.providerId,
      JSON.stringify({ products })
    );
  }

  updateCart(cart: STRCart): void {
    StorylyPlacementProvider.updateCart(
      this.providerId,
      JSON.stringify({ cart })
    );
  }

  approveCartChange(responseId: string, cart?: STRCart): void {
    StorylyPlacementProvider.approveCartChange(
      this.providerId,
      responseId,
      JSON.stringify({ cart })
    );
  }

  rejectCartChange(responseId: string, failMessage: string): void {
    StorylyPlacementProvider.rejectCartChange(
      this.providerId,
      responseId,
      failMessage
    );
  }

  approveWishlistChange(responseId: string, item?: STRProductItem): void {
    StorylyPlacementProvider.approveWishlistChange(
      this.providerId,
      responseId,
      JSON.stringify({ item })
    );
  }

  rejectWishlistChange(responseId: string, failMessage: string): void {
    StorylyPlacementProvider.rejectWishlistChange(
      this.providerId,
      responseId,
      failMessage
    );
  }

  destroy(): void {
    this.subscriptions.forEach((sub) => sub.remove());
    this.subscriptions = [];
    StorylyPlacementProvider.destroyProvider(this.providerId);
  }
}

