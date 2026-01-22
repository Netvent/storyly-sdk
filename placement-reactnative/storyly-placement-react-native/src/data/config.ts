

export interface StorylyPlacementConfig {
  token: string;
  testMode?: boolean;
  locale?: string;
  layoutDirection?: 'ltr' | 'rtl';
  customParameter?: string;
  labels?: string[];
  userProperties?: Record<string, string>;

  productConfig?: {};
  shareConfig?: {
    shareUrl?: string;
    facebookAppId?: string;
    appLogoVisibility?: boolean;
  };
  networkConfig?: {
    cdnHost?: string;
    productHost?: string;
    analyticHost?: string;
    placementHost?: string;
  };
}
