//
//  AppParticipant.m
//  JeKuDo-Beta
//
//  Created by reuven on 12/13/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "AppParticipant.h"
#import <UIKit/UIKit.h>

@implementation AppParticipant

- (UIImage *)avatarImage {
    UIImage *avatarImage = [UIImage imageWithData:self.imageData];
    if(avatarImage)
        return avatarImage;
    else
        return [UIImage imageNamed:@"avatarCurrentUser"];
}

@end
