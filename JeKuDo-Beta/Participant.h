//
//  Participant.h
//  JeKuDo-Beta
//
//  Created by reuven on 12/7/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UIImage;

NS_ASSUME_NONNULL_BEGIN

@interface Participant : NSManagedObject

- (UIImage *)avatarImage;

@end

NS_ASSUME_NONNULL_END

#import "Participant+CoreDataProperties.h"
