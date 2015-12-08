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

@property (nonatomic, strong) NSArray *participants, *admins;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, readonly) NSUInteger numberOfUnreadMessages;

@end

NS_ASSUME_NONNULL_END

#import "Group+CoreDataProperties.h"
