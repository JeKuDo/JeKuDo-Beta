//
//  SignUpViewController.m
//  Rand-iOS
//
//  Created by reuven on 9/11/15.
//  Copyright (c) 2015 JeKuDo. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "MessagesTableViewController.h"
#import "ContactsCollectionViewController.h"
//#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "EntryNavigationController.h"
#import "AppDataSource.h"
#import "User.h"
#import "AppGroup.h"
#import "UIColor+AppColors.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.title = @"Sign Up";
//        self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"navHeaderImage"]];
        //appDataSource = [AppDataSource sharedInstance];
        //        self.navigationItem.leftBarButtonItem=nil;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self dismissKeyboard];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.badFieldColor = [UIColor colorWithRed:255.0 green:0 blue:0 alpha:0.18];
    
    UITapGestureRecognizer *gestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    
    [gestureRecongnizer setNumberOfTouchesRequired:1];
//    [rightSwipe setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:gestureRecongnizer];

    
    // ui controls
//    UIScrollView *formView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    formView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *1.20f);
//    [formView addSubview:self.textFieldUsername];
//    [formView addSubview:self.textFieldName];
//    [formView addSubview:self.textFieldEmail];
//    [formView addSubview:self.textFieldPassword];
//    [formView addSubview:self.textFieldRePassword];
//    [formView addSubview:self.showPasswordsSwitch];
//    [formView addSubview:self.saveButton];
//    [formView addSubview:self.loginButton];
//    [self.view addSubview:formView];
    
    
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, self.view.frame.size.height *3)];
    

    _textFieldUsername.borderStyle = UITextBorderStyleRoundedRect;
//    _textFieldUsername.font = [UIFont systemFontOfSize:15];
    _textFieldUsername.placeholder = @"Choose a Username";
    _textFieldUsername.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFieldUsername.keyboardType = UIKeyboardTypeAlphabet;
    _textFieldUsername.autocapitalizationType = 0;
    _textFieldUsername.returnKeyType = UIReturnKeyDone;
    _textFieldUsername.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFieldUsername.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [_textFieldUsername addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_textFieldUsername addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
   
    
    _textFieldName.borderStyle = UITextBorderStyleRoundedRect;
//    _textFieldName.font = [UIFont systemFontOfSize:15];
    _textFieldName.placeholder = @"Your Real Name";
    _textFieldName.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFieldName.keyboardType = UIKeyboardTypeAlphabet;
    _textFieldName.autocapitalizationType = 1;
    _textFieldName.returnKeyType = UIReturnKeyDone;
    _textFieldName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFieldName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textFieldName addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];

    
    _textFieldEmail.borderStyle = UITextBorderStyleRoundedRect;
//    _textFieldEmail.font = [UIFont systemFontOfSize:15];
    _textFieldEmail.placeholder = @"Your Email Address";
    _textFieldEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFieldEmail.keyboardType = UIKeyboardTypeEmailAddress;
    _textFieldEmail.autocapitalizationType = 0;
    _textFieldEmail.returnKeyType = UIReturnKeyDone;
    _textFieldEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFieldEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textFieldEmail addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];

    
    _textFieldPassword.borderStyle = UITextBorderStyleRoundedRect;
//    _textFieldPassword.font = [UIFont systemFontOfSize:15];
    _textFieldPassword.placeholder = @"Create Password (min 8 characters)";
    _textFieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFieldPassword.keyboardType = UIKeyboardTypeDefault;
    _textFieldPassword.secureTextEntry = YES;
    _textFieldPassword.returnKeyType = UIReturnKeyDone;
    _textFieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFieldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textFieldPassword addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];

    
    _textFieldRePassword.borderStyle = UITextBorderStyleRoundedRect;
//    _textFieldRePassword.font = [UIFont systemFontOfSize:15];
    _textFieldRePassword.placeholder = @"Re-type Your New Password";
    _textFieldRePassword.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFieldRePassword.keyboardType = UIKeyboardTypeDefault;
    _textFieldRePassword.secureTextEntry = YES;
    _textFieldRePassword.returnKeyType = UIReturnKeyDone;
    _textFieldRePassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFieldRePassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textFieldRePassword addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    
//    [_showPasswordsSwitch setTintColor: [UIColor themePrimaryColor]];
    _showPasswordsSwitch.on = NO;
    [_showPasswordsSwitch setOnTintColor:[UIColor themeAccentColor]];
    [_showPasswordsSwitch addTarget:self action:@selector(showPasswordsToggle:) forControlEvents:UIControlEventValueChanged];

    
    [_saveButton addTarget:self
                    action:@selector(verifyForm)
          forControlEvents:UIControlEventTouchUpInside];
    _saveButton.font = [UIFont systemFontOfSize:24];
    [_saveButton setTitle:@"Join Rand!" forState:UIControlStateNormal];
    [_saveButton setBackgroundColor:[UIColor themeSecondaryColor]];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _saveButton.frame = CGRectMake(30, 426, self.view.frame.size.width-60, 60);
    [_saveButton.layer setCornerRadius:6.0];

    
    [_loginButton addTarget:self
                     action:@selector(login)
           forControlEvents:UIControlEventTouchUpInside];
    _loginButton.font = [UIFont systemFontOfSize:24];
    [_loginButton setTitle:@"Already Joined? Log In" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor themeAccentColor]];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton.layer setCornerRadius:6.0];

    
    
    
    
    
    
    
    
    self.viewOrder = @[_textFieldUsername, _textFieldName, _textFieldEmail, _textFieldPassword, _textFieldRePassword];
    self.uikitObservedOrder = [self.viewOrder copy];
    self.currentTextField = nil;
    
    [[AppDataSource sharedInstance] fetchCurrentUserWithCompletion:^(User *localUser, NSError *err) {
        if(localUser) {
            [self login];
            if(localUser.passhash) {
                [[AppDataSource sharedInstance] fetchUserWithUsername:localUser.username andPassword:localUser.passhash completion:^(User *user, NSError *error) {
                    if(error) {
                        NSLog(error.description);
                        //                        UIAlertView *failureAlert = [[UIAlertView alloc]
                        //                                                     initWithTitle:@"Oops!" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        //                        [failureAlert show];
                    }
                    if(user.passhash == localUser.passhash) {
                        _user = user;
                        [self presentAuthenticatedViews];
                    }
                }];
            }
        }
    }];
    
    
    [self populateFormWithCurrentUser];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self populateFormWithCurrentUser];
}

- (void) textFieldDidChange :(UITextField *)textField{
    [textField setBackgroundColor:[UIColor whiteColor]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    return YES;
}

- (void) dismissKeyboard {
    [_textFieldEmail resignFirstResponder];
    [_textFieldName resignFirstResponder];
    [_textFieldPassword resignFirstResponder];
    [_textFieldRePassword resignFirstResponder];
    [_textFieldUsername resignFirstResponder];
}

- (void) textFieldEditingDidBegin :(UITextField *)textField{
    [textField setBackgroundColor:[UIColor whiteColor]];
    int ii = _scrollView.contentOffset.y;
    NSLog(@"_scrollView.contentOffset.y is %d",ii);
    
//    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_scrollView setContentOffset:CGPointMake(0, ii +66) animated:YES];
}

- (void) showPasswordsToggle:(UISwitch *)showPasswordsSwitch {
    _textFieldPassword.secureTextEntry = ![showPasswordsSwitch isOn];
    _textFieldRePassword.secureTextEntry = ![showPasswordsSwitch isOn];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (BOOL) validateUsername: (NSString *) candidate {
    
    // new password requirements
    if ([candidate length] < 3) return false;
    if ([candidate length] > 32) return false;
    
    BOOL specialCharacter = 0;
    
    for (int i = 0; i < [candidate length]; i++)
    {
        unichar c = [candidate characterAtIndex:i];
        NSCharacterSet *spacing = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSCharacterSet *allowed = [NSCharacterSet characterSetWithCharactersInString:@"-_"];
        if(!specialCharacter)
        {
            //            Boolean *spaced = (Boolean)[spacing characterIsMember:c];
            if([spacing characterIsMember:c])
            {
                specialCharacter = [spacing characterIsMember:c];
            }
        }
        if(!specialCharacter)
        {
            if(![allowed characterIsMember:c])
            {
                specialCharacter = [[NSCharacterSet punctuationCharacterSet] characterIsMember:c];
            }
        }
    }
    
    if(specialCharacter)
    {
        return false;
    }
    else
    {
        return true;
    }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL) validateNewPassword: (NSString *) candidate {
    
    // new password requirements
    if ([candidate length] < 8) return false;
    if ([candidate length] > 128) return false;
    
    BOOL lowerCaseLetter,upperCaseLetter,digit,specialCharacter = 0;
    
    for (int i = 0; i < [candidate length]; i++)
    {
        unichar c = [candidate characterAtIndex:i];
        if(!lowerCaseLetter)
        {
            lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
        }
        if(!upperCaseLetter)
        {
            upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
        }
        if(!digit)
        {
            digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
        }
        //        if(!specialCharacter)
        //        {
        //            specialCharacter = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
        //        }
    }
    
//    if(specialCharacter && digit && lowerCaseLetter && upperCaseLetter)
//    {
//        return true;
//    }
//    else
//    {
//        return false;
//    }
    return true;
}

- (void) verifyForm {
    NSLog(@"save button was pushed");
    
    if (![self validateUsername:self.textFieldUsername.text]) {
        NSLog(@"username not valid");
        [self.textFieldUsername setBackgroundColor:_badFieldColor];
        UIAlertView *usernameAlert = [[UIAlertView alloc]
                                      initWithTitle:@"Username" message:@"Must contain 3-32 characters, letters and numbers only. No special characters except - and _" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [usernameAlert show];
    }
    else if (![self validateEmail:self.textFieldEmail.text]) {
        NSLog(@"email format not valid");
        [self.textFieldEmail setBackgroundColor:_badFieldColor];
        UIAlertView *emailFormatAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Email Format" message:@"The email format used appears to be invalid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emailFormatAlert show];
    }
    else {
        if (![self validateNewPassword:self.textFieldPassword.text]) {
            NSLog(@"password not good");
            [self.textFieldPassword setBackgroundColor:_badFieldColor];
            UIAlertView *passwordAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Password" message:@"Must contain 8-128 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [passwordAlert show];
        }
        else if (![self.textFieldPassword.text isEqualToString:self.textFieldRePassword.text]) {
            NSLog(@"re-password %s does not match %s", self.textFieldRePassword.text, self.textFieldPassword.text);
            [self.textFieldRePassword setBackgroundColor:_badFieldColor];
            UIAlertView *rePasswordAlert = [[UIAlertView alloc]
                                            initWithTitle:@"Confirm Password" message:@"The passwords you entered do not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [rePasswordAlert show];
        }
        else {
            NSLog(@"form passed validation");
            
            
            NSDate *nowDate = [NSDate date];
            NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"avatarCurrentUser"]);
            
            User *user = [[User alloc] initWithUsername:_textFieldUsername.text name:_textFieldName.text publicKey:@"{{public_key_goes_here}}" imageData:imageData lastUpdated:nowDate];
            [user setPrivateKey:@"{{private_key_goes_here}}"];
            [user setEmail:_textFieldEmail.text];
            [user setPasshash:_textFieldPassword.text];
            [user setPhone:@13477667708];
            [user setLastSession:nowDate];
            [user setCreated:nowDate];
            
            
            [[AppDataSource sharedInstance] saveCurrentUserData:user unique:1 withCompletion:^(User *savedUser, NSError *err) {
                if(err) {
                    NSLog(err.description);
                    UIAlertView *failureAlert = [[UIAlertView alloc]
                                                 initWithTitle:@"Oops!" message:err.description
                                                 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [failureAlert show];
                }
                else if (savedUser) {
                    UIAlertView *successAlert = [[UIAlertView alloc]
                                                 initWithTitle:@"Welcome" message:@"You have successfully joined!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [successAlert show];
//                    [appDataSource fetchCurrentUserWithCompletion:^(User *user, NSError *error) {
//                        _user = user;
//                        [self presentAuthenticatedViews];
//                    }];
                    _user = savedUser;
                    [self presentAuthenticatedViews];
                }
            }];
            
            
        }
    }
}

- (void) populateFormWithCurrentUser {
//        [self.textFieldPassword setText:@"password123"];
//        [self.textFieldRePassword setText:_textFieldPassword.text];
//        [self.textFieldEmail setText:@"admin@jekudo.com"];
//        [self.textFieldUsername setText:@"admin"];
//        [self.textFieldName setText:@"iOS Developer"];
    [[AppDataSource sharedInstance] fetchCurrentUserWithCompletion:^(User *user, NSError *err) {
        if(user) {
//            [self.textFieldPassword setText:user.passhash];
//            [self.textFieldRePassword setText:user.passhash];
//            [self.textFieldEmail setText:user.email];
//            [self.textFieldUsername setText:user.username];
//            [self.textFieldName setText:user.name];
        }
    }];
}

- (void) login {
    [[AppDataSource sharedInstance] fetchCurrentUserWithCompletion:^(User *user, NSError *error) {
        SignInViewController *signInViewController = [[SignInViewController alloc] init];
        signInViewController.currentUser = user;
        [self.navigationController pushViewController:signInViewController animated:YES];
    }];
}

- (void) loginWithUser:(User *)user {
    SignInViewController *signInViewController = [[SignInViewController alloc] init];
    signInViewController.logInWithUser = @"1";
    signInViewController.currentUser = user;
    [self.navigationController pushViewController:signInViewController animated:YES];
}

- (void) presentAuthenticatedViews {

    SignInViewController *signInViewController = [[SignInViewController alloc] init];
//    loginViewController.currentUser = user;
//    loginViewController.logInWithUser = @"1";
    [self.navigationController pushViewController:signInViewController animated:YES];

//    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
//    profileViewController.tabBarItem.image = [UIImage imageNamed:@"menuIconAccount.png"];
//    [profileViewController setTitle:@"Profile"];

    SettingsViewController *settingsViewController = [[SettingsViewController alloc]  init];
    settingsViewController.tabBarItem.image = [UIImage imageNamed:@"menuIconProfile.png"];
    [settingsViewController setTitle:@"Profile"];
    
    MessagesTableViewController *messagesTableViewController = [[MessagesTableViewController alloc] init];
    messagesTableViewController.user = _user;
    NSMutableArray *groups = [[[AppDataSource sharedInstance] fetchUserGroupsGoToServer:YES] mutableCopy];
    NSMutableArray *groupsCopy = [groups mutableCopy];
    for (AppGroup *group in groupsCopy) {
        if (group.messages.count <1)
            [groups removeObject:group];
    }
    messagesTableViewController.groups = [groups copy];

    messagesTableViewController.tabBarItem.image = [UIImage imageNamed:@"menuIconMessages.png"];
    [messagesTableViewController setTitle:@"Messages"];
    
//    ContactsTableViewController *contactsTableViewController = [[ContactsTableViewController alloc] init];
//    contactsTableViewController.tabBarItem.image = [UIImage imageNamed:@"menuIconContacts.png"];
//    [contactsTableViewController setTitle:@"Contacts"];
    ContactsCollectionViewController *contactsCollectionViewController = [[ContactsCollectionViewController alloc] initWithUsers:[[AppDataSource sharedInstance] fetchUsersByUsernames:nil excludeCurrentUser:YES]];
    contactsCollectionViewController.tabBarItem.image = [UIImage imageNamed:@"menuIconContacts.png"];
    [contactsCollectionViewController setTitle:@"Contacts"];
    
    EntryNavigationController *settingsNavigationController = [[EntryNavigationController alloc] initWithRootViewController:settingsViewController];
    
    EntryNavigationController *messagesNavigationController = [[EntryNavigationController alloc] initWithRootViewController:messagesTableViewController];
    
    EntryNavigationController *contactsNavigationController = [[EntryNavigationController alloc] initWithRootViewController:contactsCollectionViewController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.view.tintColor = [UIColor themePrimaryColor];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:messagesNavigationController, contactsNavigationController, settingsNavigationController, nil];
    
    [self presentModalViewController:tabBarController animated:YES];
}

- (void) logout {
}

@end



//- (UITextField *) textFieldUsername {
//    if(!_textFieldUsername) {
//        _textFieldUsername = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width-60, 60)];
//        _textFieldUsername.borderStyle = UITextBorderStyleRoundedRect;
//        _textFieldUsername.font = [UIFont systemFontOfSize:15];
//        _textFieldUsername.placeholder = @"Choose a Username";
//        _textFieldUsername.autocorrectionType = UITextAutocorrectionTypeNo;
//        _textFieldUsername.keyboardType = UIKeyboardTypeAlphabet;
//        _textFieldUsername.autocapitalizationType = 0;
//        _textFieldUsername.returnKeyType = UIReturnKeyDone;
//        _textFieldUsername.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _textFieldUsername.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [_textFieldUsername addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//        _textFieldUsername.delegate = self;
//    }
//    return _textFieldUsername;
//}
//
//- (UITextField *) textFieldName {
//    if(!_textFieldName) {
//        _textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(30, 96, self.view.frame.size.width-60, 60)];
//        _textFieldName.borderStyle = UITextBorderStyleRoundedRect;
//        _textFieldName.font = [UIFont systemFontOfSize:15];
//        _textFieldName.placeholder = @"Your Real Name";
//        _textFieldName.autocorrectionType = UITextAutocorrectionTypeNo;
//        _textFieldName.keyboardType = UIKeyboardTypeAlphabet;
//        _textFieldName.autocapitalizationType = 1;
//        _textFieldName.returnKeyType = UIReturnKeyDone;
//        _textFieldName.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _textFieldName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [_textFieldName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//        _textFieldName.delegate = self;
//    }
//    return _textFieldName;
//}
//
//- (UITextField *) textFieldEmail {
//    if(!_textFieldEmail) {
//        _textFieldEmail = [[UITextField alloc] initWithFrame:CGRectMake(30, 162, self.view.frame.size.width-60, 60)];
//        _textFieldEmail.borderStyle = UITextBorderStyleRoundedRect;
//        _textFieldEmail.font = [UIFont systemFontOfSize:15];
//        _textFieldEmail.placeholder = @"Your Email Address";
//        _textFieldEmail.autocorrectionType = UITextAutocorrectionTypeNo;
//        _textFieldEmail.keyboardType = UIKeyboardTypeEmailAddress;
//        _textFieldEmail.autocapitalizationType = 0;
//        _textFieldEmail.returnKeyType = UIReturnKeyDone;
//        _textFieldEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _textFieldEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [_textFieldEmail addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//        _textFieldEmail.delegate = self;
//    }
//    return _textFieldEmail;
//}
//
//- (UITextField *) textFieldPassword {
//    if(!_textFieldPassword) {
//        _textFieldPassword = [[UITextField alloc] initWithFrame:CGRectMake(30, 228, self.view.frame.size.width-60, 60)];
//        _textFieldPassword.borderStyle = UITextBorderStyleRoundedRect;
//        _textFieldPassword.font = [UIFont systemFontOfSize:15];
//        _textFieldPassword.placeholder = @"Create Password (min 8 characters)";
//        _textFieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;
//        _textFieldPassword.keyboardType = UIKeyboardTypeDefault;
//        _textFieldPassword.secureTextEntry = YES;
//        _textFieldPassword.returnKeyType = UIReturnKeyDone;
//        _textFieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _textFieldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [_textFieldPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//        _textFieldPassword.delegate = self;
//    }
//    return _textFieldPassword;
//}
//
//- (UITextField *) textFieldRePassword {
//    if(!_textFieldRePassword) {
//        _textFieldRePassword = [[UITextField alloc] initWithFrame:CGRectMake(30, 294, self.view.frame.size.width-60, 60)];
//        _textFieldRePassword.borderStyle = UITextBorderStyleRoundedRect;
//        _textFieldRePassword.font = [UIFont systemFontOfSize:15];
//        _textFieldRePassword.placeholder = @"Re-type Your New Password";
//        _textFieldRePassword.autocorrectionType = UITextAutocorrectionTypeNo;
//        _textFieldRePassword.keyboardType = UIKeyboardTypeDefault;
//        _textFieldRePassword.secureTextEntry = YES;
//        _textFieldRePassword.returnKeyType = UIReturnKeyDone;
//        _textFieldRePassword.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _textFieldRePassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [_textFieldRePassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//        _textFieldRePassword.delegate = self;
//    }
//    return _textFieldRePassword;
//}
//
//- (UISwitch *) showPasswordsSwitch {
//    if(!_showPasswordsSwitch) {
//        _showPasswordsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(30, 360, self.view.frame.size.width-60, 60)];
//
//    }
//    return _showPasswordsSwitch;
//}
//
//- (UIButton *) saveButton {
//    _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_saveButton addTarget:self
//                    action:@selector(verifyForm)
//          forControlEvents:UIControlEventTouchUpInside];
//    [_saveButton setTitle:@"Join Rand!" forState:UIControlStateNormal];
//    [_saveButton setBackgroundColor:[UIColor themePrimaryColor]];
//    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _saveButton.frame = CGRectMake(30, 426, self.view.frame.size.width-60, 60);
//    [_saveButton.layer setCornerRadius:6.0];
//    return _saveButton;
//}
//
//- (UIButton *) loginButton {
//    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_loginButton addTarget:self
//                     action:@selector(login)
//           forControlEvents:UIControlEventTouchUpInside];
//    [_loginButton setTitle:@"Log In" forState:UIControlStateNormal];
//    [_loginButton setBackgroundColor:[UIColor clearColor]];
//    [_loginButton setTitleColor:[UIColor themePrimaryColor] forState:UIControlStateNormal];
//    _loginButton.frame = CGRectMake(30, 495, self.view.frame.size.width-60, 60);
//    [_loginButton.layer setCornerRadius:6.0];
//    return _loginButton;
//}
//
