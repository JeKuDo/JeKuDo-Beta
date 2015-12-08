//
//  SignUpViewController.h
//  Rand-iOS
//
//  Created by reuven on 9/11/15.
//  Copyright (c) 2015 JeKuDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDataSource.h"


@interface SignUpViewController : UIViewController
{
    //AppDataSource *appDataSource;
}

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) IBOutlet NSURL *apiUrl;
@property (nonatomic, strong) IBOutlet NSString *apiKey;

//@property IBOutlet Boolean *isNew;
@property (assign) BOOL isNew;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet NSArray *viewOrder, *uikitObservedOrder;

@property (nonatomic, retain) IBOutlet UITextField *textFieldName, *textFieldUsername, *textFieldEmail, *textFieldPassword, *textFieldRePassword, *currentTextField;

@property (nonatomic, retain) IBOutlet UISwitch *showPasswordsSwitch;

@property (nonatomic, retain) IBOutlet UIButton *saveButton, *loginButton;

@property (nonatomic, retain) IBOutlet UIColor *badFieldColor;

//- (void)populateFormWithCurrentUser;

@end