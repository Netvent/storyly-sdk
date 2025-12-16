

export type STRWidgetType = 'banner' | 'story-bar' | 'video-feed' | 'video-feed-presenter' | 'swipe-card';

export interface PlacementWidget {
  viewId: string;
  type: STRWidgetType;
}

export interface STRDataPayload {
  type: STRWidgetType;
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

