//
//  WebServicesAPI.h
//  Rand-iOS
//
//  Created by reuven on 9/23/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServicesAPI : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) IBOutlet NSURL *apiUrl;
@property (nonatomic, strong) IBOutlet NSString *apiKey;

#pragma mark - User Methods
-(NSArray *) fetchUsers:(NSArray *)usernames;
-(NSData *) fetchUser:(NSString *)username withPasshash:(NSString *)passhash;
-(NSData *) pushCurrentUser:(NSDictionary *)userdata unique:(BOOL)unique;
-(void) pushCurrentUser:(NSDictionary *)userdata withCompletion:(void (^)(NSData *, NSError *))completion;

#pragma mark - Message Methods

-(NSData *) fetchUnreadMessagesForUsername:(NSString *)username withGroupId:(NSString *)groupId;
-(void) fetchUnreadMessagesForUsername:(NSString *)username withGroupId:(NSString *)groupId withCompletion:(void (^)(NSData *, NSError *))completion;
-(NSData *) postNewMessage:(NSDictionary *)messageData;

#pragma mark - Groups Methods

-(NSData *) fetchGroupsForUsername:(NSString *)username;
-(NSData *) createNewGroup:(NSDictionary *)groupDataDictionary;


@end
