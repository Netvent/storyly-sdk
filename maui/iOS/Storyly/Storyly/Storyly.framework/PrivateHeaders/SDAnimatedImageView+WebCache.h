/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "ST_SDAnimatedImageView.h"

#if SD_UIKIT

#import "ST_SDWebImageManager.h"

/**
 Integrates SDWebImage async downloading and caching of remote images with SDAnimatedImageView.
 */
@interface ST_SDAnimatedImageView (ST_WebCache)

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrieved from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)st_setImageWithURL:(nullable NSURL *)url
                 completed:(nullable ST_SDExternalCompletionBlock)completedBlock;

@end

#endif
