import StorylyMoments

@objc(RNStorylyMoments)
class RNStorylyMoments: NSObject {
    private var storylyMomentsManager: StorylyMomentsManager? = nil
    
    @objc(initialize:withUserPayload:)
    func initialize(token: String,
                    userPayload: String) {
        DispatchQueue.main.async {
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            self.storylyMomentsManager = StorylyMomentsManager(config: Config(momentsToken: token,
                                                                              userPayload: userPayload),
                                                               momentsDelegate: nil)
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
}
