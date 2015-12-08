//
//  GroupBadgeLabel.m
//  Rand-iOS
//
//  Created by reuven on 11/17/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "GroupBadgeLabel.h"

@implementation GroupBadgeLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:12];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:73.0f/255.0f blue:50.0f/255.0f alpha:1];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    self.layer.masksToBounds = YES;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGSize orig = [super intrinsicContentSize];
    return CGSizeMake(MAX(CGRectGetHeight(self.bounds), orig.width + 16), orig.height);
}

@end
