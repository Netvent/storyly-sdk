//
//  StorylyGroupViewManager.m
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.09.2023.
//

#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"



 @interface StorylyGroupViewManager : RCTViewManager
 @end

 @implementation StorylyGroupViewManager

 RCT_EXPORT_MODULE(StorylyGroupView)

- (UIView *)view
{
  return [[UIView alloc] init];
}

 @end
