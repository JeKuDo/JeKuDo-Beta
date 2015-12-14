//
//  AppDataSource.h
//  Rand-iOS
//
//  Created by reuven on 9/11/15.
//  Copyright (c) 2015 JeKuDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User, AppMessage, AppGroup, AppParticipant;
@class UIImage;

@interface AppDataSource : NSObject

//@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedInstance;

#pragma mark - Public User Methods

- (void)saveCurrentUserData:(User *)user unique:(BOOL)unique withCompletion:(void (^)(User *, NSError *))completion;
- (void)fetchCurrentUserWithCompletion:(void (^)(User *, NSError *))completion;
- (void)fetchUserWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(User *, NSError *))completion;
- (NSArray *)fetchUsersByUsernames:(NSArray *)usernames excludeCurrentUser:(BOOL)excludeCurrentUser;
- (void)logOutCurrentUserWithCompletion:(void (^)(NSArray *, NSError *))completion;

#pragma mark - Public Groups Methods

- (NSArray *)fetchUserGroupsGoToServer:(BOOL)goToServer;
//- (void)fetchUserGroups:(User *)user goToServer:(BOOL)goToServer withCompletion:(void (^)(NSArray *, NSError *))completion;
- (AppGroup *)createNewGroup:(AppGroup *)groupToCreate;
- (AppGroup *)fetchDMGroupWithParticipant:(AppParticipant *)participant;

#pragma mark - Public Message Methods

-(void)postNewMessage:(AppMessage *)message withCompletion:(void (^)(AppMessage *, NSError *))completion;

#pragma mark - TEST / DEV Methods

- (void)testCoreData:(BOOL)runTest;

@end
