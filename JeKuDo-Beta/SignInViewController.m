//
//  SignInViewController.m
//  Rand-iOS
//
//  Created by reuven on 12/7/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"
#import "AppDataSource.h"
#import "EntryNavigationController.h"
#import "MessagesTableViewController.h"
#import "ContactsCollectionViewController.h"
//#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "User.h"
#import "AppGroup.h"
#import "UIColor+AppColors.h"


@interface SignInViewController ()

@end

@implementation SignInViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.title = @"Log In";
        //        self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"navHeaderImage"]];
        appDataSource = [AppDataSource sharedInstance];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.badFieldColor = [UIColor colorWithRed:255.0 green:0 blue:0 alpha:0.18];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, self.view.frame.size.height *3)];
    
    // ui controls
    //    [self.view addSubview:self.textFieldUsername];
    //    [self.view addSubview:self.textFieldPassword];
    //    [self.view addSubview:self.retrieveCredentialsButton];
    //    [self.view addSubview:self.loginButton];
    
    _textFieldUsername.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldUsername.font = [UIFont systemFontOfSize:15];
    _textFieldUsername.placeholder = @"Your Username";
    _textFieldUsername.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFieldUsername.keyboardType = UIKeyboardTypeAlphabet;
    _textFieldUsername.autocapitalizationType = 0;
    _textFieldUsername.returnKeyType = UIReturnKeyDone;
    _textFieldUsername.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFieldUsername.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textFieldUsername addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //    _textFieldUsername.delegate = self;
    
    _textFieldPassword.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldPassword.font = [UIFont systemFontOfSize:15];
    _textFieldPassword.placeholder = @"Your Password";
    _textFieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFieldPassword.keyboardType = UIKeyboardTypeDefault;
    _textFieldPassword.secureTextEntry = YES;
    _textFieldPassword.returnKeyType = UIReturnKeyDone;
    _textFieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFieldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textFieldPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //    _textFieldPassword.delegate = self;
    
    _showPasswordsSwitch.on = NO;
    [_showPasswordsSwitch setOnTintColor:[UIColor themeAccentColor]];
    [_showPasswordsSwitch addTarget:self action:@selector(showPasswordsToggle:) forControlEvents:UIControlEventValueChanged];
    
    [_loginButton addTarget:self
                     action:@selector(verifyForm)
           forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor themeAccentColor]];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    _loginButton.frame = CGRectMake(30, 226, self.view.frame.size.width-60, 60);
    [_loginButton.layer setCornerRadius:6.0];
    _loginButton.font = [UIFont systemFontOfSize:24];
    
    [_retrieveCredentialsButton addTarget:self
                                   action:@selector(comingSoon)
                         forControlEvents:UIControlEventTouchUpInside];
    [_retrieveCredentialsButton setTitle:@"Forgot Password" forState:UIControlStateNormal];
    [_retrieveCredentialsButton setBackgroundColor:[UIColor clearColor]];
    [_retrieveCredentialsButton setTitleColor:[UIColor themePrimaryColor] forState:UIControlStateNormal];
    //    _retrieveCredentialsButton.frame = CGRectMake(30, 295, self.view.frame.size.width-60, 60);
    [_retrieveCredentialsButton.layer setCornerRadius:6.0];
    
    //    self.viewOrder = @[_textFieldUsername, _textFieldPassword];
    //    self.uikitObservedOrder = @[_textFieldUsername, _textFieldPassword];
    //    self.currentTextField = _textFieldUsername;
    
    [self populateFormWithCurrentUser];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self populateFormWithCurrentUser];
}

- (void)comingSoon {
    UIAlertView *comingSoonAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Comming Soon" message:@"This feature is yet to be added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [comingSoonAlert show];
}

- (void) textFieldDidChange:(UITextField *)textField{
    [textField setBackgroundColor:[UIColor whiteColor]];
}

- (BOOL) textFieldShouldReturn:(UITextField*)textField {
    //    if ([self.viewOrder containsObject:textField]) {
    //        UIResponder *nextField = [self.viewOrder objectAtIndex:([self.viewOrder indexOfObject:textField] + 1) % self.viewOrder.count];
    //        [nextField becomeFirstResponder];
    //    }
    //    else {
    //        // Unknown field, just resign first responder.
    //        [textField resignFirstResponder];
    //    }
    //    return NO;
    [self dismissKeyboard];
    return YES;
}
- (void) dismissKeyboard {
    //    [_textFieldEmail resignFirstResponder];
    //    [_textFieldName resignFirstResponder];
    [_textFieldPassword resignFirstResponder];
    //    [_textFieldRePassword resignFirstResponder];
    [_textFieldUsername resignFirstResponder];
}

- (void) showPasswordsToggle:(UISwitch *)showPasswordsSwitch {
    _textFieldPassword.secureTextEntry = ![showPasswordsSwitch isOn];
    //    _textFieldRePassword.secureTextEntry = ![showPasswordsSwitch isOn];
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

- (BOOL) validateNewPassword: (NSString *) candidate {
    
    // new password requirements
    if ([candidate length] < 1) {
        return false;
    }
    else
    {
        return true;
    }
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
    else if (![self validateNewPassword:self.textFieldPassword.text]) {
        NSLog(@"password not good");
        [self.textFieldPassword setBackgroundColor:_badFieldColor];
        UIAlertView *passwordAlert = [[UIAlertView alloc]
                                      initWithTitle:@"Password" message:@"Please enter your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [passwordAlert show];
    }
    else {
        NSLog(@"form passed validation");
        // todo: hash and salt the passwords
        [self loginWithFormValues];
    }
}

- (void) populateFormWithCurrentUser {
    
    //    [self.textFieldUsername setText:@"admin"];
    //    [self.textFieldPassword setText:@"password123"];
    if(_currentUser) {
        [self.textFieldUsername setText:_currentUser.username];
        //        [self.textFieldPassword setText:_currentUser.passhash];
    }
}

- (void) loginWithFormValues {
    [appDataSource fetchUserWithUsername:_textFieldUsername.text andPassword:_textFieldPassword.text completion:^(User *user, NSError *error) {
        if(error) {
            NSLog(error.description);
            UIAlertView *failureAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Oops!" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [failureAlert show];
        }
        if(user) {
            _textFieldPassword.text = nil;
            [appDataSource saveCurrentUserData:user unique:NO withCompletion:nil];
            _currentUser = user;
            [self presentAuthenticatedViews];
        }
        
    }];
}

- (void) presentAuthenticatedViews {
    
    //    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    //    profileViewController.tabBarItem.image = [UIImage imageNamed:@"menuIconAccount.png"];
    //    [profileViewController setTitle:@"Profile"];
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc]  init];
    settingsViewController.tabBarItem.image = [UIImage imageNamed:@"menuIconProfile.png"];
    [settingsViewController setTitle:@"Profile"];
    
    MessagesTableViewController *messagesTableViewController = [[MessagesTableViewController alloc] init];
    messagesTableViewController.user = _currentUser;
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
    ContactsCollectionViewController *contactsCollectionViewController = [[ContactsCollectionViewController alloc] init];
    contactsCollectionViewController.tabBarItem.image = [UIImage imageNamed:@"menuIconContacts.png"];
    [contactsCollectionViewController setTitle:@"Contacts"];
    
    EntryNavigationController *settingsNavigationController = [[EntryNavigationController alloc] initWithRootViewController:settingsViewController];
    
    EntryNavigationController *messagesNavigationController = [[EntryNavigationController alloc] initWithRootViewController:messagesTableViewController];
    
    EntryNavigationController *contactsNavigationController = [[EntryNavigationController alloc] initWithRootViewController:contactsCollectionViewController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.view.tintColor = [UIColor themePrimaryColor];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:messagesNavigationController, contactsNavigationController, settingsNavigationController, nil];
    
    //    [self presentModalViewController:tabBarController animated:YES];
    //    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    //    [appDelegate changeRootViewController:tabBarController animated:YES];
    
    [[AppDelegate sharedInstance] changeRootViewController:tabBarController animated:YES];
    
    
}

@end
