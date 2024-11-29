

export interface StoryComponent {
    id: string;
    type: ReactionType;
    customPayload?: string;
}

export interface StorySwipeComponent extends StoryComponent {
    text: string;
    actionUrl?: string;
    products?: STRProductItem[];
}

export interface StoryButtonComponent extends StoryComponent {
    text: string;
    actionUrl?: string;
    products?: STRProductItem[];
}

export interface StoryProductTagComponent extends StoryComponent {
    actionUrl?: string;
    products?: STRProductItem[];
}

export interface StoryProductCardComponent extends StoryComponent {
    text: string;
    actionUrl?: string;
    products?: STRProductItem[];
}

export interface StoryProductCatalogComponent extends StoryComponent {
    text: string;
    actionUrlList?: string[];
    products?: STRProductItem[];
}

export interface StoryQuizComponent extends StoryComponent {
    title: string;
    options: string[];
    rightAnswerIndex?: number;
    selectedOptionIndex: number;
}

export interface StoryPollComponent extends StoryComponent {
    title: string;
    options: string[];
    selectedOptionIndex: number;
}


export interface StoryEmojiComponent extends StoryComponent {
    emojiCodes: string[];
    selectedEmojiIndex: number;
}


export interface StoryRatingComponent extends StoryComponent {
    title: string;
    emojiCode: string;
    rating: number;
}


export interface StoryPromoCodeComponent extends StoryComponent {
    text: string;
}

export interface StoryCommentComponent extends StoryComponent {
    text: string;
}

export interface StoryGroup {
    id: string;
    title: string;
    iconUrl?: string;
    index: number;
    pinned: boolean;
    seen: boolean;
    stories: Story[];
    type: string,
    name?: string,
    nudge: boolean,
    style?: StoryGroupStyle,
};

export interface Story {
    id: string;
    index: number;
    title: string;
    name?: string;
    seen: boolean;
    currentTime?: number;
    actionUrl: string;
    previewUrl?: string;
    storyComponentList?: StoryComponent[];
    actionProducts?: STRProductItem[];
}

export interface StoryGroupStyle {
    borderUnseenColors?: [string],
    textUnseenColor?: string,
    badge?: StoryGroupBadgeStyle,
}

export interface StoryGroupBadgeStyle {
    backgroundColor?: string,
    textColor?: string,
    endTime?: number,
    template?: string,
    text?: string,
}


export type ReactionType =
    | "emoji"
    | "rating"
    | "poll"
    | "quiz"
    | "countdown"
    | "promocode"
    | "swipeaction"
    | "buttonaction"
    | "text"
    | "image"
    | "producttag"
    | "productcard"
    | "comment"
    | "video"
    | "vod";

export interface STRProductItem {
    productId: string;
    productGroupId: string;
    title: string;
    url: string;
    desc?: string;
    price: number;
    salesPrice?: number;
    currency: string;
    imageUrls?: string[];
    variants: STRProductVariant[];
    ctaText?: string;
}

export interface STRProductVariant {
    name: string;
    value: string;
    key: string;
}

export interface STRCart {
    items: STRCartItem[];
    totalPrice: number;
    oldTotalPrice?: number;
    currency: string;
}

export interface STRCartItem {
    item: STRProductItem;
    totalPrice?: number;
    oldTotalPrice?: number;
    quantity: number;
}

export interface STRProductInformation {
    productId?: string;
    productGroupId?: string;
}