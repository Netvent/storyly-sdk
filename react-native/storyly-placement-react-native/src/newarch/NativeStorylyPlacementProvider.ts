import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';


export interface Spec extends TurboModule {
  // Provider lifecycle
  createProvider(providerId: string, config: string): void;
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

// MARK: - Module Export

export default TurboModuleRegistry.getEnforcing<Spec>('StorylyPlacementProvider');


