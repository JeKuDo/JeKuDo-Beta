//
//  AppMessage.h
//  JeKuDo-Beta
//
//  Created by reuven on 12/13/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppMessage : NSObject

@property (nonatomic, strong) NSString *messageId, *sender, *groupId, *messageText, *mac;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSArray *seenByParticipantsArray;
@property (nonatomic, strong) NSDate *creationDate;

@end
