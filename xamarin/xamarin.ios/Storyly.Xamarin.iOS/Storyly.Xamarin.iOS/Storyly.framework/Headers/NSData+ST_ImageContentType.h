/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "ST_SDWebImageCompat.h"

/**
 You can use switch case like normal enum. It's also recommended to add a default case. You should not assume anything about the raw value.
 For custom coder plugin, it can also extern the enum for supported format. See `ST_SDImageCoder` for more detailed information.
 */
typedef NSInteger ST_SDImageFormat NS_TYPED_EXTENSIBLE_ENUM;
static const ST_SDImageFormat ST_SDImageFormatUndefined = -1;
static const ST_SDImageFormat ST_SDImageFormatJPEG      = 0;
static const ST_SDImageFormat ST_SDImageFormatPNG       = 1;
static const ST_SDImageFormat ST_SDImageFormatGIF       = 2;
static const ST_SDImageFormat ST_SDImageFormatWebP      = 4;

/**
 NSData category about the image content type and UTI.
 */
@interface NSData (ST_ImageContentType)

/**
 *  Return image format
 *
 *  @param data the input image data
 *
 *  @return the image format as `ST_SDImageFormat` (enum)
 */
+ (ST_SDImageFormat)st_imageFormatForImageData:(nullable NSData *)data;

/**
 *  Convert ST_SDImageFormat to UTType
 *
 *  @param format Format as ST_SDImageFormat
 *  @return The UTType as CFStringRef
 *  @note For unknown format, `kSDUTTypeImage` abstract type will return
 */
+ (nonnull CFStringRef)st_UTTypeFromImageFormat:(ST_SDImageFormat)format CF_RETURNS_NOT_RETAINED NS_SWIFT_NAME(sd_UTType(from:));

/**
 *  Convert UTType to ST_SDImageFormat
 *
 *  @param uttype The UTType as CFStringRef
 *  @return The Format as ST_SDImageFormat
 *  @note For unknown type, `ST_SDImageFormatUndefined` will return
 */
+ (ST_SDImageFormat)st_imageFormatFromUTType:(nonnull CFStringRef)uttype;

@end
