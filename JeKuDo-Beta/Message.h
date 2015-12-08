//
//  Message.h
//  JeKuDo-Beta
//
//  Created by reuven on 12/7/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSManagedObject

@property (nullable, nonatomic, retain) NSArray *seenByParticipantsArray;

@end

NS_ASSUME_NONNULL_END

#import "Message+CoreDataProperties.h"
