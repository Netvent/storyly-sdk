//
//  RCTConvert+StorylyInit.m
//  storyly-react-native
//
//  Created by Levent Oral on 12.05.2020.
//

#import "RCTConvert+StorylyInit.h"

@implementation RCTConvert (StorylyInit)

+ (StorylyInit *)STStorylyInit:(id)json {
    NSDictionary *storylyInit = [self NSDictionary:json];
    StorylySegmentationParams *storylySegmentationParams = [StorylySegmentationParams alloc];
    if ([storylyInit.allKeys containsObject:@"storylySegments"] &&
        storylyInit[@"storylySegments"] != NULL) {
        storylySegmentationParams = [storylySegmentationParams initWithSegments:storylyInit[@"storylySegments"]
                                                            dynamicSegmentation:FALSE
                                              dynamicSegmentationFilterFunction:NULL];
    }
    return [[StorylyInit alloc] initWithStorylyId:storylyInit[@"storylyId"]
                                     segmentation:storylySegmentationParams];
}

@end
