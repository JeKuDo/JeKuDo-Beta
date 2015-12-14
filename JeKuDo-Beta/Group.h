//
//  Group.h
//  JeKuDo-Beta
//
//  Created by reuven on 12/7/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Participant.h"
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Group : NSManagedObject

@property (nullable, nonatomic, retain) NSString *admins;
@property (nullable, nonatomic, retain) NSDate *created;
@property (nullable, nonatomic, retain) NSString *groupId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *participants;
@property (nullable, nonatomic, retain) NSString *publicKey;

@property (nonatomic, strong) NSArray *participantsArray, *adminsArray;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, readonly) NSUInteger numberOfUnreadMessages;

- (instancetype) initWithGroupId:(NSString *)groupId
                       name:(NSString *)name
                    created:(NSDate *)created
                  publicKey:(NSString *)publicKey
                adminsArray:(NSArray *)adminsArray
          participantsArray:(NSArray *)participantsArray;

@end

NS_ASSUME_NONNULL_END

#import "Group+CoreDataProperties.h"


/*
 @property (nullable, nonatomic, retain) NSString *admins;
 @property (nullable, nonatomic, retain) NSDate *created;
 @property (nullable, nonatomic, retain) NSString *groupId;
 @property (nullable, nonatomic, retain) NSString *name;
 @property (nullable, nonatomic, retain) NSString *participants;
 @property (nullable, nonatomic, retain) NSString *publicKey;
*/