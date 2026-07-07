import type { STRDataPayload, STRPayload } from "../events";
import type { STRProductItem } from "../product";


export interface CanvasItem {
    actionUrl?: string;
    actionProducts?: STRProductItem[];
}

export interface CanvasDataPayload extends STRDataPayload {
    items: CanvasItem[];
}

export interface STRCanvasPayload extends STRPayload {
    item?: CanvasItem;
}
