//
//  Group.m
//  JeKuDo-Beta
//
//  Created by reuven on 12/7/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "Group.h"

@implementation Group

@dynamic admins;
@dynamic participants;
@dynamic groupId, name, created, publicKey, adminsArray, participantsArray, numberOfUnreadMessages, messages;

- (instancetype) initWithGroupId:(NSString *)groupId
                       name:(NSString *)name
                    created:(NSDate *)created
                  publicKey:(NSString *)publicKey
                adminsArray:(NSArray *)adminsArray
          participantsArray:(NSArray *)participantsArray {
    
    self = [super init];
    if (self) {
//        self.groupId = groupId;
        self.name = name;
        self.created = created;
        self.publicKey = publicKey;
        self.adminsArray = adminsArray;
        self.participantsArray = participantsArray;
    }
    return self;
    
}

@end
