//
//  GroupAvatarGenerator.h
//  Rand-iOS
//
//  Created by reuven on 11/17/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupAvatarGenerator : NSObject

+ (instancetype)sharedInstance;

- (void)getAvatarImageForGroupName:(NSString *)groupName withAvatars:(NSArray *)groupAvatars withCompletionHandler:(void (^)(UIImage *avatarImage))completionHandler;

@end
