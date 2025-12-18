

export interface StorylyPlacementConfig {
  token: string;
  testMode?: boolean;
  locale?: string;
  layoutDirection?: 'ltr' | 'rtl';
  customParameter?: string;
  labels?: string[];
  userProperties?: Record<string, string>;

  productConfig?: {
    isFallbackEnabled?: boolean;
    isCartEnabled?: boolean;
  };
  shareConfig?: {
    shareUrl?: string;
    facebookAppID?: string;
    appLogoVisibility?: boolean;
  };
  networkConfig?: {
    cdnHost?: string;
    productHost?: string;
    analyticHost?: string;
    placementHost?: string;
  };
}
