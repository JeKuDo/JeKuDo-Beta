//
//  User.m
//  Rand-iOS
//
//  Created by reuven on 9/11/15.
//  Copyright (c) 2015 JeKuDo. All rights reserved.
//

#import "User.h"
#import <UIKit/UIKit.h>

@implementation User

- (instancetype)initWithUsername:(NSString *)username
                            name:(NSString *)name
                       publicKey:(NSString *)publicKey
                       imageData:(NSData *)imageData
                     lastUpdated:(NSDate *)lastUpdated
{
    self = [super init];
    if (self) {
        
        self.username = username;
        self.name = name;
        self.publicKey = publicKey;
        self.imageData = imageData;
        self.lastUpdated = lastUpdated;
    }
    return self;
}

- (UIImage *)avatarImage {
    UIImage *avatarImage = [UIImage imageWithData:self.imageData];
    if(avatarImage)
        return avatarImage;
    else
        return [UIImage imageNamed:@"avatarCurrentUser"];
}

@end
