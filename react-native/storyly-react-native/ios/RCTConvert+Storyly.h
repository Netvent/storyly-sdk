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

@interface RCTConvert (StoryGroupListStyling)

+ (StoryGroupListStyling *)STStoryGroupListStyling:(id)json;

@end

@interface RCTConvert (StoryGroupIconStyling)

+ (StoryGroupIconStyling *)STStoryGroupIconStyling:(id)json;

@end

@interface RCTConvert (StoryGroupTextStyling)

+ (StoryGroupTextStyling *)STStoryGroupTextStyling:(id)json;

+ (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr;

@end

@interface RCTConvert (StoryHeaderStyling)

+ (StoryHeaderStyling *)STStoryHeaderStyling:(id)json;

@end

@interface RCTConvert (StorylyLayoutDirection)

+ (StorylyLayoutDirection)STStorylyLayoutDirection:(NSString *)direction;

@end

NS_ASSUME_NONNULL_END
