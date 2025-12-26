
export interface StorylyPlacementProviderNative {
    // Provider lifecycle
    createProvider(providerId: string): Promise<void>;
    destroyProvider(providerId: string): void;
  
    // Configuration
    updateConfig(providerId: string, config: string): void;
  
    // Product hydration
    hydrateProducts(providerId: string, productsJson: string): void;
    hydrateWishlist(providerId: string, productsJson: string): void;
    updateCart(providerId: string, cartJson: string): void;
  
    // Event listeners
    addListener(eventName: string): void;
    removeListeners(count: number): void;
}

export interface StorylyPlacementNativeCommands {
    callWidget: (viewRef: any, id: string, method: string, raw: string) => void;
  
    approveCartChange: (viewRef: any, responseId: string, raw: string) => void;
    rejectCartChange: (viewRef: any, responseId: string, raw: string) => void;
  
    approveWishlistChange: (viewRef: any, responseId: string, raw: string) => void;
    rejectWishlistChange: (viewRef: any, responseId: string, raw: string) => void;
}