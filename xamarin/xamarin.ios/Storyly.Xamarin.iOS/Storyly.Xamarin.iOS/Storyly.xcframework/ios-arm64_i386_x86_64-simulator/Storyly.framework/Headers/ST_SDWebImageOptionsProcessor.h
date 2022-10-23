/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "ST_SDWebImageCompat.h"
#import "ST_SDWebImageDefine.h"

@class ST_SDWebImageOptionsResult;

typedef ST_SDWebImageOptionsResult * _Nullable(^ST_SDWebImageOptionsProcessorBlock)(NSURL * _Nullable url, ST_SDWebImageOptions options, ST_SDWebImageContext * _Nullable context);

/**
 The options result contains both options and context.
 */
@interface ST_SDWebImageOptionsResult : NSObject

/**
 WebCache options.
 */
@property (nonatomic, assign, readonly) ST_SDWebImageOptions options;

/**
 Context options.
 */
@property (nonatomic, copy, readonly, nullable) ST_SDWebImageContext *context;

/**
 Create a new options result.

 @param options options
 @param context context
 @return The options result contains both options and context.
 */
- (nonnull instancetype)initWithOptions:(ST_SDWebImageOptions)options context:(nullable ST_SDWebImageContext *)context;

@end

/**
 This is the protocol for options processor.
 Options processor can be used, to control the final result for individual image request's `ST_SDWebImageOptions` and `ST_SDWebImageContext`
 Implements the protocol to have a global control for each indivadual image request's option.
 */
@protocol ST_SDWebImageOptionsProcessor <NSObject>

/**
 Return the processed options result for specify image URL, with its options and context

 @param url The URL to the image
 @param options A mask to specify options to use for this request
 @param context A context contains different options to perform specify changes or processes, see `ST_SDWebImageContextOption`. This hold the extra objects which `options` enum can not hold.
 @return The processed result, contains both options and context
 */
- (nullable ST_SDWebImageOptionsResult *)processedResultForURL:(nullable NSURL *)url
                                                    options:(ST_SDWebImageOptions)options
                                                    context:(nullable ST_SDWebImageContext *)context;

@end

/**
 A options processor class with block.
 */
@interface ST_SDWebImageOptionsProcessor : NSObject<ST_SDWebImageOptionsProcessor>

- (nonnull instancetype)initWithBlock:(nonnull ST_SDWebImageOptionsProcessorBlock)block;
+ (nonnull instancetype)optionsProcessorWithBlock:(nonnull ST_SDWebImageOptionsProcessorBlock)block;

@end
