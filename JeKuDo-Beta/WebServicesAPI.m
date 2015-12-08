//
//  WebServicesAPI.m
//  Rand-iOS
//
//  Created by reuven on 9/23/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

// todo: require some kind of authentication token to identify every call to the web api
// right now we require an apikey. we can match these keys to users in the db or something

#import "WebServicesAPI.h"

@implementation WebServicesAPI

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
    if (self) {
        NSString *plist=[[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
        NSDictionary *dict=[[NSDictionary alloc] initWithContentsOfFile:plist];
        _apiUrl = [NSURL URLWithString:dict[@"apiurl"]];
        _apiKey = dict[@"apikey"];
    }
    return self;
}

#pragma mark - User Methods

-(NSArray *) fetchUsers:(NSArray *)usernames {
    NSLog(@"-(NSData *) fetchUser:(NSString *)username withPasshash:(NSString *)passhash");
    
    NSString *apiCallName = @"getusersbyusernames";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_apiUrl];
    
    [request setHTTPMethod:@"GET"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // api credentials and call settings
    [request addValue:_apiKey forHTTPHeaderField:@"apikey"];
    [request addValue:apiCallName forHTTPHeaderField:@"call"];
    
    if(usernames.count > 0)
        [request addValue:[usernames componentsJoinedByString:@","] forHTTPHeaderField:@"usernames"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return returnData;
}
-(NSData *) fetchUser:(NSString *)username withPasshash:(NSString *)passhash {
    NSLog(@"-(NSData *) fetchUser:(NSString *)username withPasshash:(NSString *)passhash");
    
    NSString *apiCallName = @"getuserinfo";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_apiUrl];
    
    [request setHTTPMethod:@"GET"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // api credentials and call settings
    [request addValue:_apiKey forHTTPHeaderField:@"apikey"];
    [request addValue:apiCallName forHTTPHeaderField:@"call"];
    
    [request addValue:username forHTTPHeaderField:@"username"];
    [request addValue:passhash forHTTPHeaderField:@"passhash"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return returnData;
}
-(NSData *) pushCurrentUser:(NSDictionary *)userdata unique:(BOOL)unique {
    NSLog(@"pushCurrentUserData");
    
    NSString *apiCallName = @"setuserinfo";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_apiUrl];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // api credentials and call settings
    [request addValue:_apiKey forHTTPHeaderField:@"apikey"];
    [request addValue:apiCallName forHTTPHeaderField:@"call"];
    
    if(!unique)
        [request addValue:@"1" forHTTPHeaderField:@"allowupdate"];
    
//    if([userdata valueForKey:@"allowupdate"])
//        [request addValue:@1 forHTTPHeaderField:@"allowupdate"];
    [request addValue:[userdata valueForKey:@"username"] forHTTPHeaderField:@"username"];
    [request addValue:[userdata valueForKey:@"name"] forHTTPHeaderField:@"name"];
    [request addValue:[userdata valueForKey:@"email"] forHTTPHeaderField:@"email"];
    [request addValue:[NSString stringWithFormat:@"%d",[userdata valueForKey:@"phone"]] forHTTPHeaderField:@"phone"];
    [request addValue:[userdata valueForKey:@"passhash"] forHTTPHeaderField:@"passhash"];
    [request addValue:[userdata valueForKey:@"publickey"] forHTTPHeaderField:@"publickey"];
    [request addValue:[NSString stringWithFormat:@"%@",[userdata valueForKey:@"created"]] forHTTPHeaderField:@"created"];
    [request addValue:[NSString stringWithFormat:@"%@",[userdata valueForKey:@"lastsession"]] forHTTPHeaderField:@"lastsession"];
    [request addValue:[NSString stringWithFormat:@"%@",[userdata valueForKey:@"lastupdated"]] forHTTPHeaderField:@"lastupdated"];
    [request addValue:[userdata valueForKey:@"imagedata"] forHTTPHeaderField:@"imagedata"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    return returnData;
    
}
-(void) pushCurrentUser:(NSDictionary *)userdata unique:(BOOL)unique withCompletion:(void (^)(NSData *, NSError *))completion {
    NSLog(@"pushCurrentUserData withCompletion");
    NSData *returnData = [self pushCurrentUser:userdata unique:unique];
    if(completion)
        completion(returnData, nil);
}

#pragma mark - Message Methods

-(NSData *) fetchUnreadMessagesForUsername:(NSString *)username withGroupId:(NSString *)groupId {
    NSLog(@"-(NSData *) fetchUnreadMessagesForUsername:(NSString *)username withGroupId:(NSString *)groupId");
    
    NSString *apiCallName = @"getgroupmessagesforuser";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_apiUrl];
    
    [request setHTTPMethod:@"GET"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // api credentials and call settings
    [request addValue:_apiKey forHTTPHeaderField:@"apikey"];
    [request addValue:apiCallName forHTTPHeaderField:@"call"];
    
    if(groupId)
        [request addValue:groupId forHTTPHeaderField:@"groupid"];
    [request addValue:username forHTTPHeaderField:@"username"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return returnData;
}
-(void) fetchUnreadMessagesForUsername:(NSString *)username withGroupId:(NSString *)groupId withCompletion:(void (^)(NSData *, NSError *))completion {
    NSLog(@"-(void) fetchUnreadMessagesForUsername:(NSString *)username withGroupId:(NSString *)groupId withCompletion:(void (^)(NSData *, NSError *))completion");
    NSData *returnData = [self fetchUnreadMessagesForUsername:username withGroupId:groupId];
    if(completion)
        completion(returnData, nil);
}
-(NSData *) postNewMessage:(NSDictionary *)messageData {
    NSLog(@"-(NSData *) postNewMessage:(NSDictionary *)messageData");
    
    NSString *apiCallName = @"postnewmessage";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_apiUrl];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // api credentials and call settings
    [request addValue:_apiKey forHTTPHeaderField:@"apikey"];
    [request addValue:apiCallName forHTTPHeaderField:@"call"];
    
    //    [request addValue:[userdata valueForKey:@"email"] forHTTPHeaderField:@"email"];
    [request addValue:[NSString stringWithFormat:@"%@",[messageData valueForKey:@"creationdate"]] forHTTPHeaderField:@"creationdate"];
    [request addValue:[messageData valueForKey:@"groupid"] forHTTPHeaderField:@"groupid"];
    [request addValue:[messageData valueForKey:@"seenbyparticipants"] forHTTPHeaderField:@"seenbyparticipants"];
    [request addValue:[messageData valueForKey:@"sender"] forHTTPHeaderField:@"sender"];
    if([messageData valueForKey:@"imagedata"])
        [request addValue:[messageData valueForKey:@"imagedata"] forHTTPHeaderField:@"imagedata"];
    if([messageData valueForKey:@"messagetext"])
        [request addValue:[messageData valueForKey:@"messagetext"] forHTTPHeaderField:@"messagetext"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    return returnData;
    
}

#pragma mark - Groups Methods

-(NSData *) fetchGroupsForUsername:(NSString *)username {
    NSLog(@"-(NSData *) fetchUnreadMessagesForUsername:(NSString *)username withGroupId:(NSString *)groupId");
    
    NSString *apiCallName = @"getgroupsforusername";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_apiUrl];
    
    [request setHTTPMethod:@"GET"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // api credentials and call settings
    [request addValue:_apiKey forHTTPHeaderField:@"apikey"];
    [request addValue:apiCallName forHTTPHeaderField:@"call"];
    
    if(username)
        [request addValue:username forHTTPHeaderField:@"username"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return returnData;
}
-(NSData *) createNewGroup:(NSDictionary *)groupDataDictionary {
    NSLog(@"-(NSData *) createNewGroup:(NSDictionary *)groupDataDictionary");
    
    NSString *apiCallName = @"retrieveorcreategroupwithparticipants";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_apiUrl];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // api credentials and call settings
    [request addValue:_apiKey forHTTPHeaderField:@"apikey"];
    [request addValue:apiCallName forHTTPHeaderField:@"call"];
    
//    [request addValue:[NSString stringWithFormat:@"%@",[groupDataDictionary valueForKey:@"creationdate"]] forHTTPHeaderField:@"creationdate"];
    [request addValue:[groupDataDictionary valueForKey:@"participants"] forHTTPHeaderField:@"participants"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    return returnData;
    
}

@end
