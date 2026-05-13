import type { PlacementWidget } from './data/events/payloads';

export interface STRWidgetController {
  pause: () => void;
  resume: () => void;
  open: ({uri}: {uri: string}) => void;
}

export interface STRStoryBarController extends STRWidgetController {
  openWithId: ({storyGroupId, storyId, playMode}: {storyGroupId: string, storyId?: string, playMode?: "storygroup" | "story" | "default"}) => void;
}

export interface STRVideoFeedController extends STRWidgetController {
  openWithId: ({feedGroupId, feedId, playMode}: {feedGroupId: string, feedId?: string, playMode?: "feedgroup" | "feed" | "default"}) => void;
}

export interface STRVideoFeedPresenterController extends STRWidgetController {
  play: () => void;
  openWithId: ({feedGroupId}: {feedGroupId: string}) => void;
}

export const createWidgetProxy = <T extends STRWidgetController>(widget: PlacementWidget, callback: (method: string, params: any) => void): T => {
    var controller: STRWidgetController = {
        pause: () => callback('pause', {}),
        resume: () => callback('resume', {}),
        open: ({uri}: {uri: string}) => callback('open', {uri}),
    };
    switch (widget.type) {
        case "story-bar":
            controller = {
                ...controller,
                openWithId: ({storyGroupId, storyId, playMode}) => callback('openWithId', {storyGroupId, storyId, playMode}),
            } as STRStoryBarController;
            break;
        case "video-feed":
            controller = {
                ...controller,
                openWithId: ({feedGroupId, feedId, playMode}: {feedGroupId: string, feedId?: string, playMode?: string}) => callback('openWithId', {feedGroupId, feedId, playMode}),
            } as STRVideoFeedController;
            break;
        case "video-feed-presenter":
            controller = {
                ...controller,
                play: () => callback('play', {}),
                openWithId: ({feedGroupId}: {feedGroupId: string}) => callback('openWithId', {feedGroupId}),
            } as STRVideoFeedPresenterController;
            break;

        case "swipe-card": break;
        case "banner": break;
    }
    return controller as T;
};
