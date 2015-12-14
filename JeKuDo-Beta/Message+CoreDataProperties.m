//
//  Message+CoreDataProperties.m
//  JeKuDo-Beta
//
//  Created by reuven on 12/14/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

@dynamic creationDate;
@dynamic groupId;
@dynamic imageData;
@dynamic mac;
@dynamic messageId;
@dynamic messageText;
@dynamic seenByParticipants;
@dynamic sender;

@end
