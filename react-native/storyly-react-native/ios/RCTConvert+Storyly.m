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
        storylySegmentation = [storylySegmentation initWithSegments:storylyInit[@"storylySegments"]];
    }
    
    bool isTestMode = ([storylyInit.allKeys containsObject:@"storylyIsTestMode"]) ? [storylyInit[@"storylyIsTestMode"] boolValue] : NO;

    return [[StorylyInit alloc] initWithStorylyId:storylyInit[@"storylyId"]
                                     segmentation:storylySegmentation
                                  customParameter:storylyInit[@"customParameter"]
                                       isTestMode:isTestMode];
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
        [storyGroupIconStyling.allKeys containsObject:@"cornerRadius"] && storyGroupIconStyling[@"cornerRadius"] != NULL) 
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
    
    BOOL isVisible = YES;
    if ([storyGroupTextStyling.allKeys containsObject:@"isVisible"] && storyGroupTextStyling[@"isVisible"] != NULL) {
        isVisible = [storyGroupTextStyling[@"isVisible"] boolValue];
    }
    
    
    UIColor* textColor = UIColor.blackColor;
    if ([storyGroupTextStyling.allKeys containsObject:@"color"] && storyGroupTextStyling[@"color"] != NULL) {
        textColor = [self getUIColorObjectFromHexString:storyGroupTextStyling[@"color"]];
    }
    
    int fontSize = 12;
    if ([storyGroupTextStyling.allKeys containsObject:@"textSize"] && storyGroupTextStyling[@"textSize"] != NULL) {
        fontSize = [storyGroupTextStyling[@"textSize"] intValue];
    }
    
    int lines = 2;
    if ([storyGroupTextStyling.allKeys containsObject:@"lines"] && storyGroupTextStyling[@"lines"] != NULL) {
        lines = [storyGroupTextStyling[@"lines"] intValue];
    }
    
    return [[StoryGroupTextStyling alloc] initWithIsVisible:isVisible
                                                      color:textColor
                                                       font:[UIFont systemFontOfSize:fontSize]
                                                      lines:lines];
}

+ (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr {
    unsigned int hexInt = 0;
    NSString *noHashString = [hexStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]];
    [scanner scanHexInt:&hexInt];
    
    CGFloat alpha, red, green, blue;
    if ([hexStr length] == 9) {
        alpha = ((hexInt & 0xFF000000) >> 24) / 255.0f;
        red = ((hexInt & 0x00FF0000) >> 16) / 255.0f;
        green = ((hexInt & 0x0000FF00) >> 8) / 255.0f;
        blue = (hexInt & 0x000000FF) / 255.0f;
    } else {
        alpha = 1;
        red = ((hexInt & 0xFF0000) >> 16) / 255.0f;
        green = ((hexInt & 0x00FF00) >>  8) / 255.0f;
        blue = (hexInt & 0x0000FF) / 255.0f;
    }
    return [[UIColor alloc] initWithRed:red
                                  green:green
                                   blue:blue
                                  alpha:alpha];
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
                                            isCloseButtonVisible:storyHeaderStyling[@"isCloseButtonVisible"]
                                                 closeButtonIcon:NULL
                                                 shareButtonIcon:NULL];
    }
    return [[StoryHeaderStyling alloc] initWithIsTextVisible:YES
                                               isIconVisible:YES
                                        isCloseButtonVisible:YES
                                             closeButtonIcon:NULL
                                             shareButtonIcon:NULL];
}

@end
