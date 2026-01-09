import type { STRDataPayload, STRPayload } from "../events";
import type { STRProductItem } from "../product";


export interface STRCanvasItem {
    actionUrl?: string;
    actionProducts?: STRProductItem[];
}

export interface CanvasDataPayload extends STRDataPayload {
    items: STRCanvasItem[];
}

export interface STRCanvasPayload extends STRPayload {
    item?: STRCanvasItem;
}
