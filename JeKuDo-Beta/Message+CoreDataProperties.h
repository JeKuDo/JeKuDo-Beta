//
//  Message+CoreDataProperties.h
//  JeKuDo-Beta
//
//  Created by reuven on 12/14/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSString *groupId;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, retain) NSString *mac;
@property (nullable, nonatomic, retain) NSString *messageId;
@property (nullable, nonatomic, retain) NSString *messageText;
@property (nullable, nonatomic, retain) NSString *seenByParticipants;
@property (nullable, nonatomic, retain) NSString *sender;

@end

NS_ASSUME_NONNULL_END
