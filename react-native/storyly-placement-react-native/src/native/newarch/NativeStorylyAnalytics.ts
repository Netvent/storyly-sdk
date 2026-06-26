import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';


export interface Spec extends TurboModule {
  // Initializes the analytics module with the given config JSON.
  initialize(config: string): void;

  // Tracks a product analytics event from the given event JSON.
  track(event: string): void;
}


// MARK: - Module Export
export default TurboModuleRegistry.get<Spec>('StorylyAnalytics');
