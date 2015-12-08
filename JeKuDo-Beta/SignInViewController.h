//
//  SignInViewController.h
//  Rand-iOS
//
//  Created by reuven on 12/7/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDataSource.h"

@class User;

@interface SignInViewController : UIViewController
{
    AppDataSource *appDataSource;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UISwitch *showPasswordsSwitch;

@property (nonatomic, strong) NSString *logInWithUser;

@property (nonatomic, strong) User *currentUser;

@property (nonatomic, retain) IBOutlet NSArray *viewOrder, *uikitObservedOrder;

@property (nonatomic, retain) IBOutlet UITextField *textFieldUsername, *textFieldPassword, *currentTextField;

@property (nonatomic, retain) IBOutlet UIButton *retrieveCredentialsButton, *loginButton;

@property (nonatomic, retain) IBOutlet UIColor *badFieldColor;

- (void)populateFormWithCurrentUser;

@end