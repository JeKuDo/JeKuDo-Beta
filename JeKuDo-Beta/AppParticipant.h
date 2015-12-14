//
//  AppParticipant.h
//  JeKuDo-Beta
//
//  Created by reuven on 12/13/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface AppParticipant : NSObject

@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSDate *lastUpdated;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *publicKey;
@property (nonatomic, retain) NSString *username;

- (UIImage *)avatarImage;

@end
