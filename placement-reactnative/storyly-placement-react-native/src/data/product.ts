

export interface STRProductVariant {
  name: string;
  value: string;
  key: string;
}

export interface STRProductItem {
  productId: string;
  productGroupId?: string;
  title?: string;
  desc?: string;
  price: number;
  salesPrice?: number;
  lowestPrice?: number;
  currency: string;
  url?: string;
  imageUrls?: string[];
  variants?: STRProductVariant[];
  ctaText?: string;
}

export interface STRProductInformation {
  productId?: string;
  productGroupId?: string;
}

export interface STRCartItem {
  product: STRProductItem;
  quantity: number;
}
