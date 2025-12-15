

export type PlacementWidgetType = 'banner' | 'story-bar' | 'video-feed' | 'swipe-card';



export interface STRDataPayload {
  type: PlacementWidgetType;
}

export interface STREventPayload {
  event: string;
  payload?: STRPayload;
}

export interface STRErrorPayload {
  event: string;
  message: string;
}


export interface STRPayload {}

