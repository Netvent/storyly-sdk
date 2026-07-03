

export interface STRProductConfig {}

export interface STRShareConfig {
  shareUrl?: string;
  facebookAppId?: string;
  appLogoVisibility?: boolean;
}

export interface STRNetworkConfig {
  cdnHost?: string;
  productHost?: string;
  analyticHost?: string;
  placementHost?: string;
}

export interface STRPlacementConfig {
  token: string;
  testMode?: boolean;
  locale?: string;
  layoutDirection?: 'ltr' | 'rtl';
  theme?: 'dark' | 'light';
  customParameter?: string;
  labels?: string[];
  userProperties?: Record<string, string>;

  productConfig?: STRProductConfig;
  shareConfig?: STRShareConfig;
  networkConfig?: STRNetworkConfig;
}
