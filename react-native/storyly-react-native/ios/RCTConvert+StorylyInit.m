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
    StorylySegmentation *storylySegmentation = [StorylySegmentation alloc];
    if ([storylyInit.allKeys containsObject:@"storylySegments"] &&
        storylyInit[@"storylySegments"] != NULL) {
        storylySegmentation = [storylySegmentation initWithSegments:storylyInit[@"storylySegments"]
                                       isDynamicSegmentationEnabled:FALSE
                                        dynamicSegmentationCallback:NULL];
    }
    return [[StorylyInit alloc] initWithStorylyId:storylyInit[@"storylyId"]
                                     segmentation:storylySegmentation];
}

@end
