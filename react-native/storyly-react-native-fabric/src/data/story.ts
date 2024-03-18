

export interface StoryComponent {
    id: string;
    type: ReactionType;
}

export interface StoryQuizComponent extends StoryComponent {
    title: string;
    options: string[];
    rightAnswerIndex?: number;
    selectedOptionIndex: number;
    customPayload?: string;
}

export interface StoryPollComponent extends StoryComponent {
    title: string;
    emojiCodes: string[];
    selectedEmojiIndex: number;
    customPayload?: string;
}

export interface StoryRatingComponent extends StoryComponent {
    title: string;
    emojiCodes: string[];
    selectedEmojiIndex: number;
    customPayload?: string;
}

export interface StoryPromoCodeComponent extends StoryComponent {
    text: string;
}

export interface StoryCommentComponent extends StoryComponent {
    text: string;
}

export interface MomentsUser {
    id?: string;
    avatarUrl?: string;
    username?: string;
}

export interface StoryGroup {
    id: string;
    title: string;
    iconUrl?: string;
    thematicIconUrls?: Record<string, string>;
    coverUrl?: string;
    index: number;
    seen: boolean;
    stories: Story[];
    type: string;
    pinned: boolean;
    momentsUser?: MomentsUser;
    nudge: boolean;
}

export interface Story {
    id: string;
    title: string;
    name: string;
    index: number;
    pinned: boolean;
    seen: boolean;
    currentTime: number;
    media: {
        type: number;
        storyComponentList?: StoryComponent[];
        actionUrl?: string;
        actionUrlList?: string[];
        previewUrl?: string;
    };
    products?: STRProductItem[];
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
    desc: string;
    price: number;
    salesPrice?: number;
    currency: string;
    imageUrls?: string[];
    url?: string;
    variants: STRProductVariant[];
    ctaText?: string;
}

export interface STRProductVariant {
    name: string;
    value: string;
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
