import type { STRProductItem } from './story';


export interface StorylyPlacementConfig {
  token: string;
  testMode?: boolean;
  locale?: string;
  layoutDirection?: 'ltr' | 'rtl';
  customParameter?: string;
  labels?: string[];
  userProperties?: Record<string, string>;

  productConfig?: {
    isFallbackEnabled?: boolean,
    isCartEnabled?: boolean,
    productFeed?: Record<string, STRProductItem[]>;
  };
  shareConfig?: {
    shareUrl?: string;
    facebookAppID?: string;
  };
  // networkConfig?: PlacementNetworkConfig;
}
