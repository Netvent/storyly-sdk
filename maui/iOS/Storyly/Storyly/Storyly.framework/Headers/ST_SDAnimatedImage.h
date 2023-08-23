/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "ST_SDWebImageCompat.h"
#import "ST_SDImageCoder.h"


/**
 This is the protocol for SDAnimatedImage class only but not for ST_SDAnimatedImageCoder. If you want to provide a custom animated image class with full advanced function, you can conform to this instead of the base protocol.
 */
@protocol ST_SDAnimatedImage <ST_SDAnimatedImageProvider>

@required
/**
 Initializes and returns the image object with the specified data, scale factor and possible animation decoding options.
 @note We use this to create animated image instance for normal animation decoding.
 
 @param data The data object containing the image data.
 @param scale The scale factor to assume when interpreting the image data. Applying a scale factor of 1.0 results in an image whose size matches the pixel-based dimensions of the image. Applying a different scale factor changes the size of the image as reported by the `size` property.
 @param options A dictionary containing any animation decoding options.
 @return An initialized object
 */
- (nullable instancetype)initWithData:(nonnull NSData *)data scale:(CGFloat)scale options:(nullable ST_SDImageCoderOptions *)options;

/**
 Initializes the image with an animated coder. You can use the coder to decode the image frame later.
 @note We use this with animated coder which conforms to `ST_SDProgressiveImageCoder` for progressive animation decoding.
 
 @param animatedCoder An animated coder which conform `ST_SDAnimatedImageCoder` protocol
 @param scale The scale factor to assume when interpreting the image data. Applying a scale factor of 1.0 results in an image whose size matches the pixel-based dimensions of the image. Applying a different scale factor changes the size of the image as reported by the `size` property.
 @return An initialized object
 */
- (nullable instancetype)initWithAnimatedCoder:(nonnull id<ST_SDAnimatedImageCoder>)animatedCoder scale:(CGFloat)scale;

@optional
// These methods are used for optional advanced feature, like image frame preloading.
/**
 Pre-load all animated image frame into memory. Then later frame image request can directly return the frame for index without decoding.
 This method may be called on background thread.
 
 @note If one image instance is shared by lots of imageViews, the CPU performance for large animated image will drop down because the request frame index will be random (not in order) and the decoder should take extra effort to keep it re-entrant. You can use this to reduce CPU usage if need. Attention this will consume more memory usage.
 */
- (void)preloadAllFrames;

/**
 Returns a Boolean value indicating whether all animated image frames are already pre-loaded into memory.
 */
@property (nonatomic, assign, readonly, getter=isAllFramesLoaded) BOOL allFramesLoaded;

/**
 Return the animated image coder if the image is created with `initWithAnimatedCoder:scale:` method.
 @note We use this with animated coder which conforms to `ST_SDProgressiveImageCoder` for progressive animation decoding.
 */
@property (nonatomic, strong, readonly, nullable) id<ST_SDAnimatedImageCoder> animatedCoder;

@end

/**
 The image class which supports animating on `SDAnimatedImageView`. You can also use it on normal UIImageView/NSImageView.
 */
@interface ST_SDAnimatedImage : UIImage <ST_SDAnimatedImage>

/**
 Current animated image format.
 */
@property (nonatomic, assign, readonly) ST_SDImageFormat animatedImageFormat;

/**
 Current animated image data, you can use this to grab the compressed format data and create another animated image instance.
 If this image instance is an animated image created by using animated image coder (which means using the API listed above or using `initWithAnimatedCoder:scale:`), this property is non-nil.
 */
@property (nonatomic, copy, readonly, nullable) NSData *animatedImageData;

/**
 The scale factor of the image.
 
 @note For UIKit, this just call super instead.
 @note For AppKit, `NSImage` can contains multiple image representations with different scales. However, this class does not do that from the design. We process the scale like UIKit. This will actually be calculated from image size and pixel size.
 */
@property (nonatomic, readonly) CGFloat scale;

// By default, animated image frames are returned by decoding just in time without keeping into memory. But you can choose to preload them into memory as well, See the description in `SDAnimatedImage` protocol.
// After preloaded, there is no huge difference on performance between this and UIImage's `animatedImageWithImages:duration:`. But UIImage's animation have some issues such like blanking and pausing during segue when using in `UIImageView`. It's recommend to use only if need.
- (void)preloadAllFrames;
@property (nonatomic, assign, readonly, getter=isAllFramesLoaded) BOOL allFramesLoaded;

@end
