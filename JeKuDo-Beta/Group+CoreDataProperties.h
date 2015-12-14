//
//  Group+CoreDataProperties.h
//  JeKuDo-Beta
//
//  Created by reuven on 12/14/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface Group (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *admins;
@property (nullable, nonatomic, retain) NSDate *created;
@property (nullable, nonatomic, retain) NSString *groupId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *participants;
@property (nullable, nonatomic, retain) NSString *publicKey;

@end

NS_ASSUME_NONNULL_END
