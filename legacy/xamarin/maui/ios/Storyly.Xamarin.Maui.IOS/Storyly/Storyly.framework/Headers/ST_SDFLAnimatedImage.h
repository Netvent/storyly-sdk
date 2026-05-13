/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "ST_SDWebImage.h"

#import "ST_FLAnimatedImage.h"


/**
 * Optimal frame cache size of ST_FLAnimatedImage during initializer. (1.0.11 version later)
 * This value will help you set `optimalFrameCacheSize` arg of ST_FLAnimatedImage initializer after image load.
 * Defaults to 0.
 */
FOUNDATION_EXPORT ST_SDWebImageContextOption _Nonnull const ST_SDWebImageContextOptimalFrameCacheSize;
/**
 * Predrawing control of ST_FLAnimatedImage during initializer. (1.0.11 version later)
 * This value will help you set `predrawingEnabled` arg of ST_FLAnimatedImage initializer after image load.
 * Defaults to YES.
 */
FOUNDATION_EXPORT ST_SDWebImageContextOption _Nonnull const SST_DWebImageContextPredrawingEnabled;

/**
 A wrapper class to allow `FLAnimatedImage` to be compatible for SDWebImage loading/cache/rendering system. The `GIF` image loading from `FLAnimatedImageView+WebCache` category, will use this subclass instead of `UIImage`.
 
 @note Though this class conforms to `SDAnimatedImage` protocol, so it's compatible to be used for `SDAnimatedImageView`. But it's normally discouraged to do so. Because it does not provide optimization for animation rendering. Instead, use `SDAnimatedImage` class with `SDAnimatedImageView`.
 */
@interface ST_SDFLAnimatedImage : UIImage <ST_SDAnimatedImage>

/**
 The `FLAnimatedImage` instance for GIF representation. This property typically be nonnull if you init the image with the following methods. However, it will be null when you call super method like `initWithCGImage:`
 */
@property (nonatomic, strong, nullable, readonly) ST_FLAnimatedImage *animatedImage;

/**
 Create the wrapper with specify `FLAnimatedImage` instance. The instance should be nonnull.
 This is a convenience method for some use cases, for example, create a placeholder with `FLAnimatedImage`.

 @param animatedImage The `FLAnimatedImage` instance
 @return An initialized object
 */
- (nonnull instancetype)initWithAnimatedImage:(nonnull ST_FLAnimatedImage *)animatedImage;


// This class override these methods from UIImage, and it supports NSSecureCoding.
// You should use these methods to create a new animated image. Use other methods just call super instead.
+ (nullable instancetype)imageWithContentsOfFile:(nonnull NSString *)path;
+ (nullable instancetype)imageWithData:(nonnull NSData *)data;
+ (nullable instancetype)imageWithData:(nonnull NSData *)data scale:(CGFloat)scale;
- (nullable instancetype)initWithContentsOfFile:(nonnull NSString *)path;
- (nullable instancetype)initWithData:(nonnull NSData *)data;
- (nullable instancetype)initWithData:(nonnull NSData *)data scale:(CGFloat)scale;

@end
