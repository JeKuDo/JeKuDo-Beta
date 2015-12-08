//
//  ConversationTableViewController.h
//  Rand-iOS
//
//  Created by reuven on 10/14/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Group.h"

@interface ConversationTableViewController : UITableViewController

@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UIView *composeView;
@property (nonatomic, strong) UITextField *sendMessageTextField;

@property (nonatomic, assign) NSUInteger initialMessageIndex;

@end
