//
//  Participant+CoreDataProperties.h
//  JeKuDo-Beta
//
//  Created by reuven on 12/14/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Participant.h"

NS_ASSUME_NONNULL_BEGIN

@interface Participant (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, retain) NSDate *lastUpdated;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *publicKey;
@property (nullable, nonatomic, retain) NSString *username;

@end

NS_ASSUME_NONNULL_END
