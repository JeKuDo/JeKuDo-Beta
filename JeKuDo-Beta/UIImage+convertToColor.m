//
//  UIImage+convertToColor.m
//  Tweetero
//
//  Created by David Keay on 2/20/14.
//
//

#import "UIImage+convertToColor.h"

@implementation UIImage (convertToColor)

- (UIImage*)convertToColor:(UIColor*)color {

    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [self drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [result imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
