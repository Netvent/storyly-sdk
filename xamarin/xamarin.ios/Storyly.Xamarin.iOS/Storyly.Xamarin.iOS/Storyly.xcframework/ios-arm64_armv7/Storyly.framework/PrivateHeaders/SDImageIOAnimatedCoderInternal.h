/*
* This file is part of the SDWebImage package.
* (c) Olivier Poitrey <rs@dailymotion.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

#import <Foundation/Foundation.h>
#import "ST_SDImageIOAnimatedCoder.h"

// kSDUTTypeWebP seems not defined in public UTI framework, Apple use the hardcode string, we define them :)
#define kSDUTTypeWebP  ((__bridge CFStringRef)@"org.webmproject.webp")
#define kSDUTTypeImage ((__bridge CFStringRef)@"public.image")
#define kSDUTTypeJPEG  ((__bridge CFStringRef)@"public.jpeg")
#define kSDUTTypePNG   ((__bridge CFStringRef)@"public.png")
#define kSDUTTypeGIF   ((__bridge CFStringRef)@"com.compuserve.gif")

@interface ST_SDImageIOAnimatedCoder ()

+ (NSTimeInterval)frameDurationAtIndex:(NSUInteger)index source:(nonnull CGImageSourceRef)source;
+ (NSUInteger)imageLoopCountWithSource:(nonnull CGImageSourceRef)source;
+ (nullable UIImage *)createFrameAtIndex:(NSUInteger)index source:(nonnull CGImageSourceRef)source scale:(CGFloat)scale preserveAspectRatio:(BOOL)preserveAspectRatio thumbnailSize:(CGSize)thumbnailSize options:(nullable NSDictionary *)options;
+ (BOOL)canEncodeToFormat:(ST_SDImageFormat)format;
+ (BOOL)canDecodeFromFormat:(ST_SDImageFormat)format;

@end
