//
//  GroupAvatarGenerator.m
//  Rand-iOS
//
//  Created by reuven on 11/17/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "GroupAvatarGenerator.h"

@interface GroupAvatarGenerator ()

@property (nonatomic, strong) NSMapTable *avatarMapTable;

@end

@implementation GroupAvatarGenerator


+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

+ (dispatch_queue_t)sharedBackgroundQueue {
    static dispatch_queue_t sharedQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = dispatch_queue_create("com.weneedglimpse.avatargenerator", NULL);
    });
    return sharedQueue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.avatarMapTable = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

- (void)getAvatarImageForGroupName:(NSString *)groupName withAvatars:(NSArray *)groupAvatars withCompletionHandler:(void (^)(UIImage *))completionHandler {
    
    UIImage *avatarImage = [self.avatarMapTable objectForKey:groupName];
    if (avatarImage)
        if (completionHandler)
            return completionHandler(avatarImage);
    
    dispatch_async([[self class] sharedBackgroundQueue], ^{
        NSMutableArray *avatarImages = [[NSMutableArray alloc] initWithArray:groupAvatars copyItems:YES];
        
        CGSize size = CGSizeMake(300, 300);
        UIGraphicsBeginImageContext(size);
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width/2] addClip];
        
        if (avatarImages.count >= 3) {
            [avatarImages[0] drawInRect:CGRectMake(-size.width/4, 0, size.width, size.height)];
            [avatarImages[1] drawInRect:CGRectMake(size.width/2, 0, size.width/2, size.height/2)];
            [avatarImages[2] drawInRect:CGRectMake(size.width/2, size.height/2, size.width/2, size.height/2)];
        } else if (avatarImages.count == 2) {
            UIImage *rightImage = avatarImages[1];
            CGImageRef rightImageRef = CGImageCreateWithImageInRect(rightImage.CGImage, CGRectMake(rightImage.size.width/4, 0, rightImage.size.width/2, rightImage.size.height));
            rightImage = [UIImage imageWithCGImage:rightImageRef];
            CGImageRelease(rightImageRef);
            
            [avatarImages[0] drawInRect:CGRectMake(-size.width/4, 0, size.width, size.height)];
            [rightImage drawInRect:CGRectMake(size.width/2, 0, size.width/2, size.height)];
        } else if (avatarImages.count == 1) {
            [avatarImages[0] drawInRect:CGRectMake(0, 0, size.width, size.height)];
        }
        
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self.avatarMapTable setObject:resultImage forKey:groupName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler)
                completionHandler(resultImage);
        });
    });
}

@end
