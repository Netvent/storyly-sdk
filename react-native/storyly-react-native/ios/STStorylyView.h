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

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
