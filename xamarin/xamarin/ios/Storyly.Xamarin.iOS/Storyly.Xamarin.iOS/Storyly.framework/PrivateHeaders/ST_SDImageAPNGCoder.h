/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "ST_SDImageIOAnimatedCoder.h"

/**
 Built in coder using ImageIO that supports APNG encoding/decoding
 */
@interface ST_SDImageAPNGCoder : ST_SDImageIOAnimatedCoder <ST_SDProgressiveImageCoder, ST_SDAnimatedImageCoder>

@property (nonatomic, class, readonly, nonnull) ST_SDImageAPNGCoder *sharedCoder;

@end
