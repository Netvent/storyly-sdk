import StorylyMoments

@objc(RNStorylyMoments)
class RNStorylyMoments: NSObject {
    private var storylyMomentsManager: StorylyMomentsManager? = nil
    
    @objc(initialize
          :withUserPayload:)
    func initialize(token: String,
                    userPayload: String) {
        DispatchQueue.main.async {
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            self.storylyMomentsManager = StorylyMomentsManager(config: Config(momentsToken: token,
                                                                              userPayload: userPayload))
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
    
    @objc(encryptUserPayload
          :withInitializationVector
          :withId:withUsername
          :withAvatarUrl
          :withFollowings
          :withCreatorTags
          :withConsumerTags
          :withExpirationTime
          :withResolver
          :withRejecter:)
    func encryptUserPayload(secretKey: String,
                            initializationVector: String,
                            id: String,
                            username: String,
                            avatarUrl: String,
                            followings: [String],
                            creatorTags: [String]?,
                            consumerTags: [String]?,
                            expirationTime: Int,
                            resolve:RCTPromiseResolveBlock,
                            reject:RCTPromiseRejectBlock) -> Void {
        resolve(
            MomentsUserPayload(id: id,
                               username: username,
                               avatarUrl: avatarUrl,
                               followings: followings,
                               creatorTags: creatorTags,
                               consumerTags: consumerTags,
                               expirationTime: Int64(expirationTime))
            .encryptUserPayload(secretKey: secretKey,
                                initializationVector: initializationVector)
        )
    }
}
