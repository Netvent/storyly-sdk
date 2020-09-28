//
//  STStorlyView.h
//
//  Created by Levent ORAL on 31.12.2019.
//

#import <React/RCTView.h>
#import <UIKit/UIKit.h>

@import Storyly;

@class RCTEventDispatcher;

NS_ASSUME_NONNULL_BEGIN

@interface STStorylyView : UIView <StorylyDelegate>

@property(nonatomic, copy) RCTBubblingEventBlock onStorylyLoaded;
@property(nonatomic, copy) RCTBubblingEventBlock onStorylyLoadFailed;
@property(nonatomic, copy) RCTBubblingEventBlock onStorylyActionClicked;
@property(nonatomic, copy) RCTBubblingEventBlock onStorylyStoryPresented;
@property(nonatomic, copy) RCTBubblingEventBlock onStorylyStoryDismissed;
@property(nonatomic, copy) RCTBubblingEventBlock onStorylyUserInteracted;

- (void)refresh;
- (void)open;
- (void)close;
- (BOOL)openStory:(NSURL *)payload;
- (BOOL)openStory:(NSNumber *)storyGroupId:(NSNumber *)storyId;
- (BOOL)setExternalData:(NSArray<NSDictionary *> *)externalData;

@end

NS_ASSUME_NONNULL_END
