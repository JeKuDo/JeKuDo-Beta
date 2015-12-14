
//
//  AppDataSource.m
//  Rand-iOS
//
//  Created by reuven on 9/11/15.
//  Copyright (c) 2015 JeKuDo. All rights reserved.
//

#import "AppDataSource.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "WebServicesAPI.h"
#import "Participant.h"
#import "Message.h"
#import "Group.h"
#import "User.h"

// data collection names
#define CURRENT_USER @"CurrentUser"
#define PARTICIPANTS @"Participants"
#define GROUPS @"Groups"
#define MESSAGES @"Messages"
//#define KEYS @"Keys"

@interface AppDataSource()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation AppDataSource

int messageLifespanSeconds = 60*60*72;

+ (instancetype) sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    if(self ) {
        _managedObjectContext = [[AppDelegate sharedInstance] managedObjectContext];
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        //        NSDictionary *d = [self.userDefaults dictionaryRepresentation];
    }
    return self;
}

#pragma mark - Public Methods

- (void)testCoreData:(BOOL)runTest {
    if (runTest)
    {
        NSManagedObject *newGroup = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Group"
                                     inManagedObjectContext:_managedObjectContext];
        [newGroup setValue:@"Test Group Name via Core Data" forKey:@"name"];
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        NSLog(@"completed testCoreData");
    }
}

// users
- (void)fetchCurrentUserWithCompletion:(void (^)(User *, NSError *))completion {
    User *user = [self fetchCurrentUser];
    if(completion)
        completion(user, nil);
}
- (void)saveCurrentUserData:(User *)user unique:(BOOL)unique withCompletion:(void (^)(User *, NSError *))completion {
    [self pushCurrentUser:user unique:unique withCompletion:^(User *savedUser, NSError *err) {
        if(savedUser) {
            [self pushCurrentUserToLocalData:savedUser];
        }
        if(completion)
            completion(savedUser,err);
    }];
}
- (void)logOutCurrentUserWithCompletion:(void (^)(NSArray *, NSError *))completion {
    User *user = [self fetchCurrentUser];
    [user setPasshash:nil];
    NSDictionary * userData = [self userDictionaryFromAppUser:user];
    [self pushLocalDataArray:CURRENT_USER withArray:@[userData]];
    if(completion)
        completion(nil, nil);
}
- (void)fetchUserWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(User *, NSError *))completion {
    NSDictionary *userData = [self fetchUserDataFromServer:username withPasshash:password];
    User *user;
    NSError *err;
    if([userData valueForKey:@"error"])
        err = [userData valueForKey:@"error"];
    else
        user = [self appUserFromDictionary:userData];
    if(completion)
        completion(user, err);
}
- (NSArray *)fetchUsersByUsernames:(NSArray *)usernames excludeCurrentUser:(BOOL)excludeCurrentUser {
    User *currentUser = [self fetchCurrentUser];
    NSArray *allUsers = [self appUsersFromUsernameArray:usernames];
    NSMutableArray *filteredUsers = [allUsers mutableCopy];
    if(excludeCurrentUser) {
        for (User *user in allUsers) {
            if([user.username isEqualToString:currentUser.username])
                [filteredUsers removeObject:user];
        }
    }
    return [NSArray arrayWithArray:filteredUsers];
}

// groups
- (NSArray *)fetchUserGroupsGoToServer:(BOOL)goToServer {
    NSArray *groupsData = [self fetchUsersGroupsDataGoToServer:goToServer];
    NSArray *groups = [self appGroupArrayFromDictionaryArray:groupsData];
    groups = [self getUserMessagesForGroups:groups goToServer:goToServer];
    return groups;
}
- (Group *)createNewGroup:(Group *)groupToCreate {
    return [self createNewGroupFromData:[self groupDictionaryFromAppGroup:groupToCreate]];
}
- (Group *)fetchDMGroupWithParticipant:(Participant *)participant {
    NSArray *groups = [self fetchUserGroupsGoToServer:NO];
    for (Group *group in groups) {
        for (Participant *groupParticipant in group.participants) {
            if ([groupParticipant.username isEqualToString:participant.username]) {
                [group setName:participant.username];
                NSArray *groupsWithMessages = [self getUserMessagesForGroups:@[group] goToServer:YES];
                return groupsWithMessages[0];
            }
        }
    }
    Group *group = [[Group alloc] init];
    NSMutableArray *participants = [[NSMutableArray alloc] init];
    [participants addObject:[self fetchCurrentUser]];
    [participants addObject:participant];
    [group setParticipants:participants];
    [group setName:participant.username];
    group = [self createNewGroup:group];
    NSArray *groupsWithMessages = [self getUserMessagesForGroups:@[group] goToServer:YES];
    return groupsWithMessages[0];
}

// messages
- (void)postNewMessage:(Message *)message withCompletion:(void (^)(Message *, NSError *))completion {
    
    Message *savedMessage;
    NSError *err;
    
    NSMutableDictionary *messageDictionaryFromAppMessage = [[self messageDictionaryFromAppMessage:message] mutableCopy];
    
    NSDictionary *savedMessageData = [self postNewMessageDataToServer:messageDictionaryFromAppMessage];
    
    if([savedMessageData valueForKey:@"error"])
        err = [savedMessageData valueForKey:@"error"];
    else
        savedMessage = [self appMessageFromDictionary:savedMessageData];
    
    if(completion)
        completion(savedMessage, err);
}

#pragma mark - Private Methods

// users
- (NSDictionary *) fetchCurrentUserData {
    NSArray *dArr = [self fetchLocalDataArray:CURRENT_USER];
    NSDictionary *d;
    if(dArr.count < 1) {
        //        d = [self fetchUserFromAPI: withPasshash:<#(NSString *)#>]
        return nil;
    }
    else {
        d = [NSDictionary dictionaryWithDictionary:dArr[0]];
        return d;
    }
}
- (User *) fetchCurrentUser {
    return [self appUserFromDictionary:[self fetchCurrentUserData]];
}
- (void)pushCurrentUser:(User *)user unique:(BOOL)unique withCompletion:(void (^)(User *, NSError *))completion {
    
    User *savedUser;
    NSError *err;
    
    NSMutableDictionary *userDictionaryFromAppUser = [[self userDictionaryFromAppUser:user] mutableCopy];
    
    NSDictionary *savedUserData = [self pushCurrentUserDataToServer:[userDictionaryFromAppUser copy] unique:unique];
    
    if([savedUserData valueForKey:@"error"])
        err = [savedUserData valueForKey:@"error"];
    else
        savedUser = [self appUserFromDictionary:savedUserData];
    
    if(completion)
        completion(savedUser, err);
}
- (NSArray *)appUsersFromUsernameArray:(NSArray *)usernames {
    NSArray *usersDataArray = [self fetchUsersDataByUsernamesFromServer:usernames];
    NSArray *usersArray = [self appUserArrayFromDictionaryArray:usersDataArray];
    return [NSArray arrayWithArray:usersArray];
}

// groups
- (NSArray *) fetchUsersGroupsDataGoToServer:(BOOL)goToServer {
    NSArray *groups;
    User *user = [self fetchCurrentUser];
    if(user) {
        if(goToServer) {
        //            groups = [self fetchGroupsDataForUsernameFromServer:user.username];
            groups = [self fetchGroupsDataForUsernameFromServer:user.username];
        }
        else {
            groups = [self fetchUsersGroupsLocalData];
            if(!groups)
                groups = [self fetchGroupsDataForUsernameFromServer:user.username];
//                groups = [self fetchGroupsDataForUsernameFromServer:user.username];
        }
    }
    return groups;
}
- (NSArray *) fetchUsersGroupsLocalData {
    NSArray *dArr = [self fetchLocalDataArray:GROUPS];
    if(dArr.count < 1) {
        return nil;
    }
    else {
        return dArr;
    }
}
- (Group *)createNewGroupFromData:(NSDictionary *)groupDataDictionary {
    NSDictionary *d = [self createNewGroupOnServer:groupDataDictionary];
    return [self appGroupFromDictionary:d];
}

// messages
- (NSArray *) getUserMessagesForGroups:(NSArray *)groups goToServer:(BOOL)goToServer {
    if(goToServer)
        groups = [self getUserMessagesForGroupsFromServer:groups];
    else
        groups = [self getUserMessagesForGroupsFromLocalData:groups];
    return groups;
}
- (NSArray *) getUserMessagesForGroupsFromLocalData:(NSArray *)groups {
    for (Group *group in groups) {
        //        NSString *username = [[self fetchCurrentUser] valueForKey:@"username"];
        //        NSArray *messages = [self fetchUnreadMessagesDataForUsernameFromServer:username];
        //        [group setMessages:messages];
    }
    return groups;
}
- (NSArray *) getUserMessagesForGroupsFromServer:(NSArray *)groups {
    for (Group *group in groups) {
        NSString *username = [[self fetchCurrentUser] valueForKey:@"username"];
        NSArray *messages = [self fetchUnreadMessagesDataForUsernameFromServer:username withGroupId:group.groupId];
        messages = [self appMessageArrayFromDictionaryArray:messages];
        [group setMessages:messages];
    }
    return groups;
}


#pragma mark - Helper Methods

- (NSString *) encodeImageToBase64String:(UIImage *)image {
    //    return [image base64Encoding];
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *) decodeBase64ToImage:(NSString *)strEncodeData {
    if(strEncodeData) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        return [UIImage imageWithData:data];
    }
    else {
        return nil;
    }
}

#pragma mark - Helper Methods - Data Object Conversion

// users
- (User *)appUserFromDictionary:(NSDictionary *)dictionary {
    if(!dictionary)
        return nil;
    if(![dictionary valueForKey:@"username"])
        return nil;
    if([[dictionary valueForKey:@"username"] isEqualToString:@""])
        return nil;
    NSData *imageData;
    if(!
       [[dictionary valueForKey:@"imagedata"] isKindOfClass:[NSNull class]]) {
        UIImage *i = [self decodeBase64ToImage:[dictionary valueForKey:@"imagedata"]];
        imageData = UIImagePNGRepresentation(i);
    }
    else {
        UIImage *i = [UIImage imageNamed:@"avatarCurrentUser"];
        imageData = UIImagePNGRepresentation(i);
    }
    User *user = [[User alloc] initWithUsername:[dictionary valueForKey:@"username"] name:[dictionary valueForKey:@"name"] publicKey:[dictionary valueForKey:@"publickey"] imageData:imageData lastUpdated:[dictionary valueForKey:@"lastupdated"]];
//    [user set_id:[dictionary valueForKey:@"_id"]];
    [user setPrivateKey:[dictionary valueForKey:@"privatekey"]];
    [user setEmail:[dictionary valueForKey:@"email"]];
    [user setPasshash:[dictionary valueForKey:@"passhash"]];
    [user setPhone:[dictionary valueForKey:@"phone"]];
    [user setLastSession:[dictionary valueForKey:@"lastsession"]];
    [user setCreated:[dictionary valueForKey:@"created"]];
    return user;
}
- (NSDictionary *)userDictionaryFromAppUser:(User *)user {
    if(!user)
        return nil;
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    if(user.username)
    {
        [userDictionary setObject:user.username forKey:@"username"];
//        if(user._id)
//            [userDictionary setObject:user._id forKey:@"_id"];
        if(user.name)
            [userDictionary setObject:user.name forKey:@"name"];
        if(user.email)
            [userDictionary setObject:user.email forKey:@"email"];
        if(user.passhash)
            [userDictionary setObject:user.passhash forKey:@"passhash"];
        if(user.privateKey)
            [userDictionary setObject:user.privateKey forKey:@"privatekey"];
        if(user.publicKey)
            [userDictionary setObject:user.publicKey forKey:@"publickey"];
        if(user.phone)
            [userDictionary setObject:user.phone forKey:@"phone"];
        if(user.lastUpdated)
            [userDictionary setObject:user.lastUpdated forKey:@"lastupdated"];
        if(user.lastSession)
            [userDictionary setObject:user.lastSession forKey:@"lastsession"];
        if(user.created)
            [userDictionary setObject:user.created forKey:@"created"];
        NSString *imageData = [self encodeImageToBase64String:[UIImage imageWithData:user.imageData]];
        if(imageData)
            [userDictionary setObject:imageData forKey:@"imagedata"];
    }
    return userDictionary;
}
- (NSArray *)userDictionaryArrayFromUserArray:(NSArray *)userArray {
    NSMutableArray *userDictionaries = [[NSMutableArray alloc] init];
    for (User *user in userArray) {
        NSDictionary *userDictionary = [self userDictionaryFromAppUser:user];
        if(userDictionary)
            [userDictionaries addObject:userDictionary];
    }
    return [NSArray arrayWithArray:userDictionaries];
}
- (NSArray *)appUserArrayFromDictionaryArray:(NSArray *)userDictionaryArray {
    NSMutableArray *users = [[NSMutableArray alloc] init];
    for (NSDictionary *userData in userDictionaryArray) {
        Message *user = [self appUserFromDictionary:userData];
        if(user)
            [users addObject:user];
    }
    return users;
}
- (NSString *)usernamesStringFromUserArray:(NSArray *)users {
    NSMutableArray *usernames = [[NSMutableArray alloc] init];
    for (NSDictionary *u in users) {
        [usernames addObject:[u valueForKey:@"username"]];
    }
    return [usernames componentsJoinedByString:@","];
}

// groups
- (Group *)appGroupFromDictionary:(NSDictionary *)dictionary {
    if(!dictionary)
        return nil;
    if(![dictionary valueForKey:@"_id"])
        return nil;
    if([[dictionary valueForKey:@"_id"] isEqualToString:@""])
        return nil;
    
    Group *group = [[Group alloc] initWithGroupId:[dictionary valueForKey:@"_id"]
                                        name:[dictionary valueForKey:@"name"]
                                     created:[dictionary valueForKey:@"created"]
                                   publicKey:[dictionary valueForKey:@"publickey"]
                                 adminsArray:[self fetchUsersByUsernames:[dictionary valueForKey:@"admins"] excludeCurrentUser:NO]
                           participantsArray:[self fetchUsersByUsernames:[dictionary valueForKey:@"participants"] excludeCurrentUser:NO]];
    
//    Group *group = [[Group alloc] init];
//    group.groupId = [dictionary valueForKey:@"_id"];
//    [group setGroupId:[dictionary valueForKey:@"_id"]];
//    [group setName:[dictionary valueForKey:@"name"]];
//    [group setCreated:[dictionary valueForKey:@"created"]];
//    [group setPublicKey:[dictionary valueForKey:@"publickey"]];
//    [group setParticipants: [self fetchUsersByUsernames:[dictionary valueForKey:@"participants"] excludeCurrentUser:NO]];
//    [group setAdmins: [self fetchUsersByUsernames:[dictionary valueForKey:@"admins"] excludeCurrentUser:NO]];
    
    return group;
}
- (NSDictionary *)groupDictionaryFromAppGroup:(Group *)group {
    if(!group)
        return nil;
    NSMutableDictionary *groupDictionary = [[NSMutableDictionary alloc] init];
    if(group.groupId)
        [groupDictionary setObject:group.groupId forKey:@"_id"];
    if(group.name)
        [groupDictionary setObject:group forKey:@"name"];
    if(group.created)
        [groupDictionary setObject:group forKey:@"created"];
    if(group.publicKey)
        [groupDictionary setObject:group forKey:@"publickey"];
    if(group.participants)
        [groupDictionary setObject:[self usernamesStringFromUserArray:group.participants] forKey:@"participants"];
    if(group.admins)
        [groupDictionary setObject:[self usernamesStringFromUserArray:group.admins] forKey:@"admins"];
    return [NSDictionary dictionaryWithDictionary: groupDictionary];
}
- (NSArray *)groupDictionaryArrayFromGroupArray:(NSArray *)groupArray {
    NSMutableArray *groupDictionaries = [[NSMutableArray alloc] init];
    for (Group *group in groupArray) {
        NSDictionary *groupDictionary = [self groupDictionaryFromAppGroup:group];
        if(groupDictionary)
            [groupDictionaries addObject:groupDictionary];
    }
    return [NSArray arrayWithArray:groupDictionaries];
}
- (NSArray *)appGroupArrayFromDictionaryArray:(NSArray *)groupDictionaryArray {
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    for (NSDictionary *groupData in groupDictionaryArray) {
        Group *group = [self appGroupFromDictionary:groupData];
        if(group)
            [groups addObject:group];
    }
    return groups;
}

// messages
- (Message *)appMessageFromDictionary:(NSDictionary *)dictionary {
    if(!dictionary)
        return nil;
    if(![dictionary valueForKey:@"_id"])
        return nil;
    if([[dictionary valueForKey:@"_id"] isEqualToString:@""])
        return nil;
    
    Message *message = [[Message alloc] init];
    [message setMessageId:[dictionary valueForKey:@"_id"]];
    [message setCreationDate:[dictionary valueForKey:@"creationdate"]];
    [message setGroupId:[dictionary valueForKey:@"groupid"]];
    [message setImageData:[dictionary valueForKey:@"imagedata"]];
    [message setMac:[dictionary valueForKey:@"mac"]];
    [message setMessageText:[dictionary valueForKey:@"messagetext"]];
    [message setSeenByParticipants:[dictionary valueForKey:@"seenbyparticipants"]];
    [message setSender:[dictionary valueForKey:@"sender"]];
    
    return message;
}
- (NSDictionary *)messageDictionaryFromAppMessage:(Message *)message {
    if(!message)
        return nil;
    NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] init];
    if(message.messageId)
        [messageDictionary setObject:message.messageId forKey:@"_id"];
    if(message.creationDate)
        [messageDictionary setObject:message.creationDate forKey:@"creationdate"];
    if(message.groupId)
        [messageDictionary setObject:message.groupId forKey:@"groupid"];
    if(message.imageData)
        [messageDictionary setObject:message.imageData forKey:@"imagedata"];
    if(message.mac)
        [messageDictionary setObject:message.mac forKey:@"mac"];
    if(message.messageText)
        [messageDictionary setObject:message.messageText forKey:@"messagetext"];
    if(message.seenByParticipantsArray)
        [messageDictionary setObject:[message.seenByParticipantsArray componentsJoinedByString:@","] forKey:@"seenbyparticipants"];
    if(message.sender)
        [messageDictionary setObject:message.sender forKey:@"sender"];
    
    return messageDictionary;
}
- (NSArray *)messageDictionaryArrayFromMessageArray:(NSArray *)messageArray {
    NSMutableArray *messageDictionaries = [[NSMutableArray alloc] init];
    for (Message *message in messageArray) {
        NSDictionary *messageDictionary = [self messageDictionaryFromAppMessage:message];
        if(messageDictionary)
            [messageDictionaries addObject:messageDictionary];
    }
    return [NSArray arrayWithArray:messageDictionaries];
}
- (NSArray *)appMessageArrayFromDictionaryArray:(NSArray *)messageDictionaryArray {
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    for (NSDictionary *messageData in messageDictionaryArray) {
        Message *message = [self appMessageFromDictionary:messageData];
        if(message)
            [messages addObject:message];
    }
    return messages;
}

#pragma mark - Web Services

- (NSDictionary *)fetchUserDataFromServer:(NSString *)username withPasshash:(NSString *)passhash {
    NSLog(@"- (NSDictionary *)fetchUserFromServer:(NSString *)username withPasshash:(NSString *)passhash");
    NSData *returnData = [[WebServicesAPI sharedInstance] fetchUser:username withPasshash:passhash];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if(!returnData)
    {
        return nil;
    }
    else
    {
        NSError *error;
        NSArray *res = [NSJSONSerialization JSONObjectWithData:returnData
                                                       options:0
                                                         error:&error];
        if (! res) {
            if(error)
                NSLog(@"Got an error: %@", error.description);
        } else {
            if(res.count > 0) {
                return res[0];
            }
            else
            {
                // no groups
                return nil;
            }
        }
        // finish
    }
    return nil;
}
- (NSArray *)fetchUsersDataByUsernamesFromServer:(NSArray *)usernames {
    NSData *returnData = [[WebServicesAPI sharedInstance] fetchUsers:usernames];
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if(!returnData)
    {
        return nil;
    }
    else
    {
        NSError *error;
        NSArray *res = [NSJSONSerialization JSONObjectWithData:returnData
                                                       options:0
                                                         error:&error];
        if (! res) {
            if(error)
                NSLog(@"Got an error: %@", error.description);
        } else {
            if(res.count > 0) {
                return res;
            }
            else
            {
                // no groups
                return nil;
            }
        }
        // finish
    }
    return nil;
}
- (NSDictionary *)pushCurrentUserDataToServer:(NSDictionary *)userdata unique:(BOOL)unique {
    NSLog(@"pushCurrentUserData");
    
    NSData *returnData = [[WebServicesAPI sharedInstance] pushCurrentUser:userdata unique:unique];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if(!returnData)
    {
        return nil;
    }
    else
    {
        NSError *error;
        NSArray *res = [NSJSONSerialization JSONObjectWithData:returnData
                                                       options:0
                                                         error:&error];
        if (! res) {
            if(error)
                NSLog(@"Got an error: %@", error.description);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"something went wrong :-(" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alert show];
            
        } else {
            if(res.count > 0) {
                return res[0];
            }
            else
            {
                // no groups
                return nil;
            }
        }
        // finish
    }
    return nil;
}
- (NSDictionary *)createNewGroupOnServer:(NSDictionary *)groupdata {
    NSLog(@"- (NSDictionary *)createNewGroupOnServer:(NSDictionary *)groupdata");
    
    NSData *returnData = [[WebServicesAPI sharedInstance] createNewGroup:groupdata];
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if(!returnData)
    {
        return nil;
    }
    else
    {
        NSError *error;
        NSArray *res = [NSJSONSerialization JSONObjectWithData:returnData
                                                       options:0
                                                         error:&error];
        if (! res) {
            if(error)
                NSLog(@"Got an error: %@", error.description);
        } else {
            if(res.count > 0) {
                return res[0];
            }
            else
            {
                // no groups
                return nil;
            }
        }
        // finish
    }
    return nil;
}
- (NSArray *)fetchGroupsDataForUsernameFromServer:(NSString *)username {
    NSLog(@"- (NSArray *)fetchGroupsDataForUsernameFromServer:(NSString *)username");
//    if (username) {
        NSData *returnData = [[WebServicesAPI sharedInstance] fetchGroupsForUsername:username];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        if(!returnData)
        {
            return nil;
        }
        else
        {
            NSError *error;
            NSArray *res = [NSJSONSerialization JSONObjectWithData:returnData
                                                           options:0
                                                             error:&error];
            if (! res) {
                if(error)
                    NSLog(@"Got an error: %@", error.description);
            } else {
                if(res.count > 0) {
                    return res;
                }
                else
                {
                    // no groups
                    return nil;
                }
            }
            // finish
        }
//    }
    return nil;
}
- (NSArray *)fetchUnreadMessagesDataForUsernameFromServer:(NSString *)username withGroupId:(NSString *)groupId {
    NSLog(@"- (NSArray *)fetchUnreadMessagesDataForUsernameFromServer:(NSString *)username");
    if (username) {
        NSData *returnData = [[WebServicesAPI sharedInstance] fetchUnreadMessagesForUsername:username withGroupId:groupId];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        if(!returnData)
        {
            return nil;
        }
        else
        {
            NSError *error;
            NSArray *res = [NSJSONSerialization JSONObjectWithData:returnData
                                                           options:0
                                                             error:&error];
            if (! res) {
                if(error)
                    NSLog(@"Got an error: %@", error.description);
            } else {
                if(res.count > 0) {
                    return res;
                }
                else
                {
                    // no groups
                    return nil;
                }
            }
            // finish
        }
    }
    return nil;
}
- (NSDictionary *)postNewMessageDataToServer:(NSDictionary *)messagedata {
    NSLog(@"- (NSDictionary *)postNewMessageDataToServer:(NSDictionary *)messagedata");
    
    NSData *returnData = [[WebServicesAPI sharedInstance] postNewMessage:messagedata];
    if(!returnData)
    {
        return nil;
    }
    else
    {
        NSError *error;
        NSArray *res = [NSJSONSerialization JSONObjectWithData:returnData
                                                       options:0
                                                         error:&error];
        if (! res) {
            if(error)
                NSLog(@"Got an error: %@", error.description);
            return nil;
        } else {
            if(res.count > 0) {
                return res[0];
            }
            else
            {
                return nil;
            }
        }
    }
    return nil;
}

#pragma mark - Local Data Storage

/*
 *
 * We need to move local storage from NSUserDefautls to Core Data
 *
 */

- (NSArray *) fetchLocalDataArray:(NSString *)collection {
    NSString *objectName = [NSString stringWithFormat:@"appData%@", collection];
    NSDictionary *prefsDict = [_userDefaults dictionaryRepresentation];
    if([[prefsDict valueForKey:objectName] isKindOfClass:[NSArray class]])
    {
        return [prefsDict valueForKey:objectName];
    }
    else
    {
        return nil;
    }
}
- (void) pushLocalDataArray:(NSString *)collection withArray:(NSArray *)array {
    NSString *objectName = [NSString stringWithFormat:@"appData%@", collection];
    [_userDefaults setValue:array forKey:objectName];
    [_userDefaults synchronize];
    //    NSDictionary *prefsDict = [_userDefaults dictionaryRepresentation];
}
- (void) pushArrayObjectsToLocalDataArray:(NSString *)collection withArray:(NSArray *)array {
    NSMutableArray *storedData = [[NSMutableArray alloc] initWithArray:[self fetchLocalDataArray:collection]];
    for(NSDictionary *item in array) {
        if(![storedData containsObject:item])
            [storedData addObject:item];
    }
    NSArray *dataToStore = [[NSArray alloc] initWithArray:storedData];
    [self pushLocalDataArray:collection withArray:dataToStore];
}
- (NSArray *) addDictionaryToArray:(NSDictionary *)dictionaryToAdd targetArray:(NSArray *)targetArray {
    NSLog(@"addObjectToArray targetArray");
    NSMutableArray *mArr = [targetArray mutableCopy];
    if(![mArr containsObject:dictionaryToAdd])
        [mArr addObject:dictionaryToAdd];
    return [[NSArray alloc] initWithArray:mArr];
}
- (void) pushCurrentUserToLocalData:(User *)currentUser {
    NSLog(@"pushCurrentUserToLocalData");
    NSArray *dataToStore = [[NSArray alloc] initWithObjects:[self userDictionaryFromAppUser:currentUser],nil];
    [self pushLocalDataArray:CURRENT_USER withArray:dataToStore];
}

@end
