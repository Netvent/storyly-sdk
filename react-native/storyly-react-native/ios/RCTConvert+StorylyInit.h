//
//  RCTConvert+StorylyInit.h
//  storyly-react-native
//
//  Created by Levent Oral on 12.05.2020.
//

#import <React/RCTConvert.h>
@import Storyly;

NS_ASSUME_NONNULL_BEGIN

@interface RCTConvert (StorylyInit)

+ (StorylyInit *)STStorylyInit:(id)json;

@end

NS_ASSUME_NONNULL_END
