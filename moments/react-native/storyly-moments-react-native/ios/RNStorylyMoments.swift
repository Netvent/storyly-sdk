import StorylyMoments
import React

@objc(RNStorylyMoments)
class RNStorylyMoments: RCTEventEmitter {
    private var storylyMomentsManager: StorylyMomentsManager? = nil

    private let EVENT_STORYLY_MOMENTS_EVENT = "storylyMomentsEvent"
    private let EVENT_STORYLY_MOMENTS_OPEN_MY_STORY = "onOpenMyStory"
    private let EVENT_STORYLY_MOMENTS_USER_STORIES_LOADED = "onUserStoriesLoaded"
    private let EVENT_STORYLY_MOMENTS_OPEN_STORY_CREATE = "onOpenCreateStory"
    private let EVENT_STORYLY_MOMENTS_USER_STORIES_LOAD_FAILED = "onUserStoriesLoadFailed"
    
    @objc(initialize:withUserPayload:)
    func initialize(token: String,
                    userPayload: String) {
        DispatchQueue.main.async {
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            self.storylyMomentsManager = StorylyMomentsManager(config: Config(momentsToken: token,
                                                                              userPayload: userPayload),
                                                               momentsDelegate: self)
            self.storylyMomentsManager?.rootViewController = rootViewController
        }
    }
    
    @objc
    func openUserStories() {
        DispatchQueue.main.async {
            self.storylyMomentsManager?.openMyStories()
        }
    }
    
    @objc
    func openStoryCreator() {
        DispatchQueue.main.async {
            self.storylyMomentsManager?.createStory()
        }
    }

    @objc override public static func requiresMainQueueSetup() -> Bool {
        return true
    }

    @objc open override func supportedEvents() -> [String] {
        return [EVENT_STORYLY_MOMENTS_EVENT,
                EVENT_STORYLY_MOMENTS_OPEN_STORY_CREATE,
                EVENT_STORYLY_MOMENTS_OPEN_MY_STORY,
                EVENT_STORYLY_MOMENTS_USER_STORIES_LOADED,
                EVENT_STORYLY_MOMENTS_USER_STORIES_LOAD_FAILED]
    }
}

extension RNStorylyMoments: MomentsDelegate {
    func storylyMomentsEvent(event: StorylyMomentsEvent, storyGroup: MomentsStoryGroup?, stories: [MomentsStory]?) {
        let body: [String: Any?] = ["eventName": event.stringValue, 
                                    "storyGroup": createMomentsStoryGroup(storyGroup: storyGroup),
                                    "stories": stories?.compactMap { createMomentsStory(story: $0) }]
        self.sendEvent(withName: EVENT_STORYLY_MOMENTS_EVENT, body: body)
    }
    
     func onOpenMyStory() {
        self.sendEvent(withName: EVENT_STORYLY_MOMENTS_OPEN_MY_STORY, body: [] )
    }
    
    func onOpenCreateStory(isDirectMediaUpload: Bool) {
        self.sendEvent(withName: EVENT_STORYLY_MOMENTS_OPEN_STORY_CREATE, body: ["isDirectMediaUpload": isDirectMediaUpload] )
    }
    
    func onUserStoriesLoaded(storyGroup: MomentsStoryGroup?) {
        self.sendEvent(withName: EVENT_STORYLY_MOMENTS_USER_STORIES_LOADED, body: ["storyGroup":  createMomentsStoryGroup(storyGroup: storyGroup) ])

    }
    
    func onUserStoriesLoadFailed(errorMessage: String) {
        self.sendEvent(withName: EVENT_STORYLY_MOMENTS_USER_STORIES_LOAD_FAILED, body: ["errorMessage": errorMessage] )
    }
}

extension RNStorylyMoments {
    private func createMomentsStoryGroup(storyGroup: MomentsStoryGroup?) -> [String: Any?]? {
        guard let storyGroup = storyGroup else { return nil }
        return [
            "id": storyGroup.id,
            "iconUrl": storyGroup.iconUrl,
            "seen": storyGroup.seen,
            "stories": storyGroup.stories.compactMap { createMomentsStory(story: $0) },
        ]
    }

    private func createMomentsStory(story: MomentsStory?) -> [String: Any?]? {
        guard let story = story else { return nil }
        return [
            "id": story.id,
            "title": story.title,
            "seen": story.seen,
            "media": [
                "type": story.type == .Image ? "Image" : "Unknown",
                "action": nil, // TODO: found in android but not ios
            ]
        ]
    }
}