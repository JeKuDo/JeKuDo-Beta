//
//  MessagesTableViewController.h
//  Rand-iOS
//
//  Created by reuven on 9/29/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface MessagesTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) User *user;

@end
