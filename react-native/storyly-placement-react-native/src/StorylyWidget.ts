import type { PlacementWidget } from './data/events/payloads';

export interface STRWidgetController {}

export interface STRStoryBarController extends STRWidgetController {
  pause: () => void;
  resume: () => void;
  close: () => void;
  open: ({uri}: {uri: string}) => void;
  openWithId: ({storyGroupId, storyId, playMode}: {storyGroupId: string, storyId?: string, playMode?: string}) => void;
}

export interface STRVideoFeedController extends STRWidgetController {
  pause: () => void;
  resume: () => void;
  close: () => void;
  open: ({uri}: {uri: string}) => void;
  openWithId: ({groupId, itemId, playMode}: {groupId: string, itemId?: string, playMode?: string}) => void;
}

export interface STRVideoFeedPresenterController extends STRWidgetController {
  pause: () => void;
  play: () => void;
  open: ({groupId}: {groupId: string}) => void;
}

export const createWidgetProxy = <T extends STRWidgetController>(widget: PlacementWidget, callback: (method: string, params: any) => void): T => {
    var controller: STRWidgetController = {};
    switch (widget.type) {
        case "story-bar":
            controller = {
                pause: () => callback('pause', {}),
                resume: () => callback('resume', {}),
                close: () => callback('close', {}),
                open: ({uri}) => callback('open', {uri}),
                openWithId: ({storyGroupId, storyId, playMode}) => callback('openWithId', {storyGroupId, storyId, playMode}),
            } as STRStoryBarController;
            break;
        case "video-feed":
            controller = {
                pause: () => callback('pause', {}),
                resume: () => callback('resume', {}),
                close: () => callback('close', {}),
                open: ({uri}: {uri: string}) => callback('open', {uri}),
                openWithId: ({groupId, itemId, playMode}: {groupId: string, itemId?: string, playMode?: string}) => callback('openWithId', {groupId, itemId, playMode}),
            };
            break;
        case "video-feed-presenter":
            controller = {
                pause: () => callback('pause', {}),
                play: () => callback('play', {}),
                open: ({groupId}: {groupId: string}) => callback('open', {groupId}),
            };
            break;

        case "swipe-card": break;
        case "banner": break;
    }
    return controller as T;
};
