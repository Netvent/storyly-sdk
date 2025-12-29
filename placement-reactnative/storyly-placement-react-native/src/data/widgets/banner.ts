import type { STRDataPayload, STRPayload } from '../events';
import type { STRProductItem } from '../product';


export type BannerComponentType = 
  | 'button';


export interface BannerComponent {
  type: BannerComponentType;
  id: string;
  customPayload?: string;
}

export interface BannerButtonComponent extends BannerComponent {
  text?: string;
  actionUrl?: string;
  products?: STRProductItem[];
}

export type BannerComponentUnion = BannerButtonComponent;


export interface STRBannerItem {
  id: string;
  name?: string;
  index: number;
  actionUrl?: string;
  componentList?: BannerComponentUnion[];
  actionProducts?: STRProductItem[];
  currentTime?: number;
}

export interface BannerDataPayload extends STRDataPayload {
  items: STRBannerItem[];
}

export interface STRBannerPayload extends STRPayload {
  item?: STRBannerItem;
  component?: BannerComponentUnion;
}
