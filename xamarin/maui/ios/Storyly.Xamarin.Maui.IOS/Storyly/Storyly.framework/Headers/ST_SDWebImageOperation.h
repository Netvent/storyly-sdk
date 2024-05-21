/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>

/// A protocol represents cancelable operation.
@protocol ST_SDWebImageOperation <NSObject>

- (void)cancel;

@end

/// NSOperation conform to `ST_SDWebImageOperation`.
@interface NSOperation (ST_SDWebImageOperation) <ST_SDWebImageOperation>

@end
