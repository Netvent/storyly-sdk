//
//  RCTConvert+StorylyInit.m
//  storyly-react-native
//
//  Created by Levent Oral on 12.05.2020.
//

#import "RCTConvert+Storyly.h"

@implementation RCTConvert (StorylyInit)

+ (StorylyInit *)STStorylyInit:(id)json {
    NSDictionary *storylyInit = [self NSDictionary:json];
    StorylySegmentation *storylySegmentation = [StorylySegmentation alloc];
    if ([storylyInit.allKeys containsObject:@"storylySegments"] &&
        storylyInit[@"storylySegments"] != NULL) {
        storylySegmentation = [storylySegmentation initWithSegments:storylyInit[@"storylySegments"]
                                       isDynamicSegmentationEnabled:NO
                                        dynamicSegmentationCallback:NULL];
    }
    return [[StorylyInit alloc] initWithStorylyId:storylyInit[@"storylyId"]
                                     segmentation:storylySegmentation
                                     customParameter:storylyInit[@"customParameter"]];
}

@end

@implementation RCTConvert (StoryGroupListStyling)

+ (StoryGroupListStyling *)STStoryGroupListStyling:(id)json {
    NSDictionary *storyGroupListStyling = [self NSDictionary:json];
    if ([storyGroupListStyling.allKeys containsObject:@"edgePadding"] && storyGroupListStyling[@"edgePadding"] != NULL &&
        [storyGroupListStyling.allKeys containsObject:@"paddingBetweenItems"] && storyGroupListStyling[@"paddingBetweenItems"] != NULL) {
        return [[StoryGroupListStyling alloc] initWithEdgePadding:[storyGroupListStyling[@"edgePadding"] floatValue]
                                               paddingBetweenItems:[storyGroupListStyling[@"paddingBetweenItems"] floatValue]];
    }
    return [[StoryGroupListStyling alloc] initWithEdgePadding:4
                                          paddingBetweenItems:8];
}

@end

@implementation RCTConvert (StoryGroupIconStyling)

+ (StoryGroupIconStyling *)STStoryGroupIconStyling:(id)json {
    NSDictionary *storyGroupIconStyling = [self NSDictionary:json];
    if ([storyGroupIconStyling.allKeys containsObject:@"height"] && storyGroupIconStyling[@"height"] != NULL &&
        [storyGroupIconStyling.allKeys containsObject:@"width"] && storyGroupIconStyling[@"width"] != NULL &&
        [storyGroupIconStyling.allKeys containsObject:@"cornerRadius"] && storyGroupIconStyling[@"cornerRadius"] != NULL &&
        [storyGroupIconStyling.allKeys containsObject:@"paddingBetweenItems"] && storyGroupIconStyling[@"paddingBetweenItems"] != NULL) 
    {
        return [[StoryGroupIconStyling alloc] initWithHeight:[storyGroupIconStyling[@"height"] floatValue]
                                                       width:[storyGroupIconStyling[@"width"] floatValue]
                                                cornerRadius:[storyGroupIconStyling[@"cornerRadius"] floatValue]];
    } 
    return [[StoryGroupIconStyling alloc] initWithHeight:80
                                                   width:80
                                            cornerRadius:40];
}

@end

@implementation RCTConvert (StoryGroupTextStyling)

+ (StoryGroupTextStyling *)STStoryGroupTextStyling:(id)json {
    NSDictionary *storyGroupTextStyling = [self NSDictionary:json];
    if ([storyGroupTextStyling.allKeys containsObject:@"isVisible"] && storyGroupTextStyling[@"isVisible"] != NULL) {
        return [[StoryGroupTextStyling alloc] initWithIsVisible:storyGroupTextStyling[@"isVisible"]];
    }
    return [[StoryGroupTextStyling alloc] initWithIsVisible:YES];
}

@end

@implementation RCTConvert (StoryHeaderStyling)

+ (StoryHeaderStyling *)STStoryHeaderStyling:(id)json {
    NSDictionary *storyHeaderStyling = [self NSDictionary:json];
    if ([storyHeaderStyling.allKeys containsObject:@"isTextVisible"] && storyHeaderStyling[@"isTextVisible"] != NULL &&
        [storyHeaderStyling.allKeys containsObject:@"isIconVisible"] && storyHeaderStyling[@"isIconVisible"] != NULL &&
        [storyHeaderStyling.allKeys containsObject:@"isCloseButtonVisible"] && storyHeaderStyling[@"isCloseButtonVisible"] != NULL)
    {
        return [[StoryHeaderStyling alloc] initWithIsTextVisible:storyHeaderStyling[@"isTextVisible"] 
                                                   isIconVisible:storyHeaderStyling[@"isIconVisible"]
                                            isCloseButtonVisible:storyHeaderStyling[@"isCloseButtonVisible"]];
    }
    return [[StoryHeaderStyling alloc] initWithIsTextVisible:YES
                                               isIconVisible:YES
                                        isCloseButtonVisible:YES];
}

@end
