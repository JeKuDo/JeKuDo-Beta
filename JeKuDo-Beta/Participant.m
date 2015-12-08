//
//  Participant.m
//  JeKuDo-Beta
//
//  Created by reuven on 12/7/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "Participant.h"
#import <UIKit/UIKit.h>

@implementation Participant

- (UIImage *)avatarImage {
    UIImage *avatarImage = [UIImage imageWithData:self.imageData];
    if(avatarImage)
        return avatarImage;
    else
        return [UIImage imageNamed:@"avatarCurrentUser"];
}

@end
