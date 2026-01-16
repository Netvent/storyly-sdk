import type { BaseEvent } from "../util";
import type { STRProductInformation } from "../product";
import type { STRDataPayload } from "./payloads";


export interface PlacementLoadEvent extends BaseEvent {
    dataSource: string;
    data: STRDataPayload;
}

export interface PlacementLoadFailEvent extends BaseEvent {
    errorMessage: string;
}

export interface PlacementHydrationEvent extends BaseEvent {
    products: STRProductInformation[];
}
