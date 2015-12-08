//
//  UIColor+AppColors.m
//  Rand-iOS
//
//  Created by reuven on 9/12/15.
//  Copyright (c) 2015 JeKuDo. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (JeKuDo)

+ (UIColor *)themePrimaryColor {
    static id sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [UIColor colorWithRed:18.0f/255.0f green:22.0f/255.0f blue:64.0f/255.0f alpha:1];
    });
    return sharedInstance;
}

+ (UIColor *)themeSecondaryColor {
    static id sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [UIColor colorWithRed:215.0f/255.0f green:54.0f/255.0f blue:51.0f/255.0f alpha:1];
    });
    return sharedInstance;
}

+ (UIColor *)themeAccentColor {
    static id sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        //        sharedInstance = [UIColor colorWithRed:22.0f/255.0f green:126.0f/255.0f blue:251.0f/255.0f alpha:1];
        sharedInstance = [UIColor colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1];
    });
    return sharedInstance;
}

+ (UIColor *)themeLightBackgroundColor {
    static id sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [UIColor colorWithRed:249.0f/255.0f green:249.0f/255.0f blue:249.0f/255.0f alpha:1];
    });
    return sharedInstance;
}

@end
