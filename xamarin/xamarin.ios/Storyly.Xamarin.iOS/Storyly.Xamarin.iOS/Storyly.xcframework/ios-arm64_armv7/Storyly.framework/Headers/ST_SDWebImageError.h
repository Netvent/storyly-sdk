/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Jamie Pinkham
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "ST_SDWebImageCompat.h"

FOUNDATION_EXPORT NSErrorDomain const _Nonnull ST_SDWebImageErrorDomain;

/// The response instance for invalid download response (NSURLResponse *)
FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull ST_SDWebImageErrorDownloadResponseKey;
/// The HTTP status code for invalid download response (NSNumber *)
FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull ST_SDWebImageErrorDownloadStatusCodeKey;
/// The HTTP MIME content type for invalid download response (NSString *)
FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull ST_SDWebImageErrorDownloadContentTypeKey;

/// SDWebImage error domain and codes
typedef NS_ERROR_ENUM(ST_SDWebImageErrorDomain, ST_SDWebImageError) {
    ST_SDWebImageErrorInvalidURL = 1000, // The URL is invalid, such as nil URL or corrupted URL
    ST_SDWebImageErrorBadImageData = 1001, // The image data can not be decoded to image, or the image data is empty
    ST_SDWebImageErrorCacheNotModified = 1002, // The remote location specify that the cached image is not modified, such as the HTTP response 304 code. It's useful for `ST_SDWebImageRefreshCached`
    ST_SDWebImageErrorBlackListed = 1003, // The URL is blacklisted because of unrecoverable failure marked by downloader (such as 404), you can use `.retryFailed` option to avoid this
    ST_SDWebImageErrorInvalidDownloadOperation = 2000, // The image download operation is invalid, such as nil operation or unexpected error occur when operation initialized
    ST_SDWebImageErrorInvalidDownloadStatusCode = 2001, // The image download response a invalid status code. You can check the status code in error's userInfo under `ST_SDWebImageErrorDownloadStatusCodeKey`
    ST_SDWebImageErrorCancelled = 2002, // The image loading operation is cancelled before finished, during either async disk cache query, or waiting before actual network request. For actual network request error, check `NSURLErrorDomain` error domain and code.
    ST_SDWebImageErrorInvalidDownloadResponse = 2003, // When using response modifier, the modified download response is nil and marked as failed.
    ST_SDWebImageErrorInvalidDownloadContentType = 2004, // The image download response a invalid content type. You can check the MIME content type in error's userInfo under `ST_SDWebImageErrorDownloadContentTypeKey`
};
