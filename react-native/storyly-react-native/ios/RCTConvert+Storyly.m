//
//  RCTConvert+StorylyInit.m
//  storyly-react-native
//
//  Created by Levent Oral on 12.05.2020.
//

#import "RCTConvert+Storyly.h"

@implementation RCTConvert (StorylyInit)

+ (StorylyInit *)STStorylyInit:(id)json {
    NSDictionary *storylyInitJson = [self NSDictionary:json];
    StorylySegmentation *storylySegmentation = [StorylySegmentation alloc];
    if ([storylyInitJson.allKeys containsObject:@"storylySegments"] &&
        storylyInitJson[@"storylySegments"] != NULL) {
        storylySegmentation = [storylySegmentation initWithSegments:storylyInitJson[@"storylySegments"]];
    }
    
    bool isTestMode = ([storylyInitJson.allKeys containsObject:@"storylyIsTestMode"]) ? [storylyInitJson[@"storylyIsTestMode"] boolValue] : NO;

    StorylyInit *storylyInit = [[StorylyInit alloc] initWithStorylyId:storylyInitJson[@"storylyId"]
                                                         segmentation:storylySegmentation
                                                      customParameter:storylyInitJson[@"customParameter"]
                                                           isTestMode:isTestMode];
    [storylyInit setUserData:storylyInitJson[@"userProperty"]];
    return storylyInit;
}

@end

@implementation RCTConvert (StoryGroupListStyling)

+ (StoryGroupListStyling *)STStoryGroupListStyling:(id)json {
    NSDictionary *storyGroupListStyling = [self NSDictionary:json];
    
    float edgePadding = 4;
    if ([storyGroupListStyling.allKeys containsObject:@"edgePadding"] && storyGroupListStyling[@"edgePadding"] != NULL) {
        edgePadding = [storyGroupListStyling[@"edgePadding"] floatValue];
    }
    
    float paddingBetweenItems = 8;
    if ([storyGroupListStyling.allKeys containsObject:@"paddingBetweenItems"] && storyGroupListStyling[@"paddingBetweenItems"] != NULL) {
        paddingBetweenItems = [storyGroupListStyling[@"paddingBetweenItems"] floatValue];
    }

    return [[StoryGroupListStyling alloc] initWithEdgePadding:edgePadding
                                          paddingBetweenItems:paddingBetweenItems];
}

@end

@implementation RCTConvert (StoryGroupIconStyling)

+ (StoryGroupIconStyling *)STStoryGroupIconStyling:(id)json {
    NSDictionary *storyGroupIconStyling = [self NSDictionary:json];
    
    float height = 80;
    if ([storyGroupIconStyling.allKeys containsObject:@"height"] && storyGroupIconStyling[@"height"] != NULL) {
        height = [storyGroupIconStyling[@"height"] floatValue];
    }
    
    float width = 80;
    if ([storyGroupIconStyling.allKeys containsObject:@"width"] && storyGroupIconStyling[@"width"] != NULL) {
        width = [storyGroupIconStyling[@"width"] floatValue];
    }
    
    float cornerRadius = 40;
    if ([storyGroupIconStyling.allKeys containsObject:@"cornerRadius"] && storyGroupIconStyling[@"cornerRadius"] != NULL) {
        cornerRadius = [storyGroupIconStyling[@"cornerRadius"] floatValue];
    }
    

    return [[StoryGroupIconStyling alloc] initWithHeight:height
                                                   width:width
                                            cornerRadius:cornerRadius];
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

    UIColor textColorSeen = NULL;
    if ([storyGroupTextStyling.allKeys containsObject:@"colorSeen"] && storyGroupTextStyling[@"colorSeen"] != NULL) {
        textColorSeen = [self getUIColorObjectFromHexString:storyGroupTextStyling[@"colorSeen"]];
    }

    UIColor textColorSeen = NULL;
    if ([storyGroupTextStyling.allKeys containsObject:@"colorUnseen"] && storyGroupTextStyling[@"colorUnseen"] != NULL) {
        textColorSeen = [self getUIColorObjectFromHexString:storyGroupTextStyling[@"colorUnseen"]];
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
                                                      colorSeen:colorSeen
                                                      colorUnseen:colorUnseen
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
    
    BOOL isTextVisible = YES;
    if ([storyHeaderStyling.allKeys containsObject:@"isTextVisible"] && storyHeaderStyling[@"isTextVisible"] != NULL) {
        isTextVisible = [storyHeaderStyling[@"isTextVisible"] boolValue];
    }
    
    BOOL isIconVisible = YES;
    if ([storyHeaderStyling.allKeys containsObject:@"isIconVisible"] && storyHeaderStyling[@"isIconVisible"] != NULL) {
        isIconVisible = [storyHeaderStyling[@"isIconVisible"] boolValue];
    }
    
    BOOL isCloseButtonVisible = YES;
    if ([storyHeaderStyling.allKeys containsObject:@"isCloseButtonVisible"] && storyHeaderStyling[@"isCloseButtonVisible"] != NULL) {
        isCloseButtonVisible = [storyHeaderStyling[@"isCloseButtonVisible"] boolValue];
    }

    return [[StoryHeaderStyling alloc] initWithIsTextVisible:isTextVisible
                                               isIconVisible:isIconVisible
                                        isCloseButtonVisible:isCloseButtonVisible
                                             closeButtonIcon:NULL
                                             shareButtonIcon:NULL];
}

@end
