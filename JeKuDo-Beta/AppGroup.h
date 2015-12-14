//
//  AppGroup.h
//  JeKuDo-Beta
//
//  Created by reuven on 12/13/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppParticipant.h"
#import "AppMessage.h"

@interface AppGroup : NSObject

@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSString *groupId, *name, *publicKey;
@property (nonatomic, strong) NSArray *participantsArray, *adminsArray;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, readonly) NSUInteger numberOfUnreadMessages;

@end
