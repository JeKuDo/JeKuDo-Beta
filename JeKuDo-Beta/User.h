//
//  User.h
//  Rand-iOS
//
//  Created by reuven on 9/11/15.
//  Copyright (c) 2015 JeKuDo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface User : NSObject

@property (nullable, nonatomic, retain) NSData *imageData, *lastUpdated;
@property (nullable, nonatomic, retain) NSString *name, *publicKey, *username, *privateKey,*passhash,*email;
@property (nonatomic, strong) NSNumber *phone;
@property (nonatomic, strong) NSDate *lastSession,*created;

- (instancetype)initWithUsername:(NSString *)username
                            name:(NSString *)name
                       publicKey:(NSString *)publicKey
                       imageData:(NSData *)imageData
                     lastUpdated:(NSDate *)lastUpdated;

- (UIImage *)avatarImage;

@end
