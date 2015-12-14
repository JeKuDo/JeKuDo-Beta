//
//  ConversationTableViewController.m
//  Rand-iOS
//
//  Created by reuven on 10/14/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "ConversationTableViewController.h"
#import "ReceivedTextTableViewCell.h"
#import "SentTextTableViewCell.h"
#import "Message.h"
#import "UIColor+AppColors.h"
#import "UIImage+convertToColor.h"
#import "AppDataSource.h"

@interface ConversationTableViewController ()

//@property UIEdgeInsets *insets;

@end

@implementation ConversationTableViewController

static NSString * const receivedTextCellIdentifier = @"receivedTextCellIdentifier";
static NSString * const sentTextCellIdentifier = @"sentTextCellIdentifier";

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[ReceivedTextTableViewCell class] forCellReuseIdentifier:receivedTextCellIdentifier];
    [self.tableView registerClass:[SentTextTableViewCell class] forCellReuseIdentifier:sentTextCellIdentifier];
    
//    if(_user && _group)
//        [self setTitle:[self messageRecipient:_group.participants].username];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.initialMessageIndex != NSNotFound)
        if(self.initialMessageIndex > 0)
            if(self.initialMessageIndex <= _group.messages.count)
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.initialMessageIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    //    self.navigationController.toolbarHidden = NO;
    //    UIToolbar *toolbar = self.navigationController.toolbar;
    //    [self.navigationController.toolbar addSubview:[self composeView]];
    
    _composeView = [self composeView];
    [self.navigationController.view addSubview:_composeView];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, _composeView.frame.size.height, 0.0);
    
    self.tableView.contentInset = contentInsets;
    
    self.tableView.scrollIndicatorInsets = contentInsets;

    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(comingSoon)];
    
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [leftSwipe setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftSwipe];
    
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(comingSoon)];
    
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [rightSwipe setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightSwipe];
    
    
//    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    
//    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
//    [downSwipe setNumberOfTouchesRequired:1];
//    [self.view addGestureRecognizer:downSwipe];
    
    
    UITapGestureRecognizer *touchDown = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [touchDown setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:touchDown];
    
    
    UIImage *closeButtonImage = [[UIImage imageNamed:@"menuIconClose@2x.png"] convertToColor:[UIColor themePrimaryColor]];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0.0, 0.0, closeButtonImage.size.width, closeButtonImage.size.height);
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [closeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = closeBarButtonItem;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods

- (UIView *)composeView {
    
    _composeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height -23, self.navigationController.toolbar.frame.size.width, 45)];
    
    [_composeView setBackgroundColor:[UIColor themeLightBackgroundColor]];
    
    _sendMessageTextField = [[UITextField alloc] initWithFrame:CGRectMake(54, 0, _composeView.frame.size.width -90, _composeView.frame.size.height)];
    _sendMessageTextField.returnKeyType = UIReturnKeySend;
    _sendMessageTextField.delegate = self;
    
    
    [_sendMessageTextField setPlaceholder:@"type a message"];
    
    [_composeView addSubview:_sendMessageTextField];
    
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(9, 6, 30, 30)];
    UIImage *cameraButtonImage = [UIImage imageNamed:@"menuIconCamera@2x.png"];
    [cameraButton setBackgroundImage:[cameraButtonImage convertToColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    
    [_composeView addSubview:cameraButton];
    
    UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(_composeView.frame.size.width -39, 6, 30, 30)];
    UIImage *photoButtonImage = [UIImage imageNamed:@"menuIconPhoto@2x.png"];
    [photoButton setBackgroundImage:[photoButtonImage convertToColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    
    [_composeView addSubview:photoButton];
    
    return _composeView;
}

-(void)goBack{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)comingSoon {
    UIAlertView *comingSoonAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Comming Soon" message:@"Swipe right/left to navigate between conversations." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [comingSoonAlert show];
}

- (void)refresh {
    NSLog(@"refresh");
    [self dismissKeyboard];
    
    
    
    
    [self.refreshControl endRefreshing];
}

- (void)dismissKeyboard {
    [_sendMessageTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *messageText = textField.text;
    if(messageText) {
        Message *messageToSend = [[Message alloc] init];
        [messageToSend setMessageId:nil];
        [messageToSend setCreationDate:[NSDate date]];
        [messageToSend setGroupId:_group.groupId];
        [messageToSend setImageData:nil];
        [messageToSend setMac:@""];
        [messageToSend setMessageText:messageText];
        [messageToSend setSeenByParticipants:@[_user.username]];
        [messageToSend setSender:_user.username];
        [self prepareToPostNewMessage:messageToSend];
    }
    return YES;
}

- (void)prepareToPostNewMessage:(Message *)messageToSend {
    _sendMessageTextField.text = @"";
    if(messageToSend.groupId)
    {
        NSLog(@"groupid: %@", messageToSend.groupId);
        messageToSend = [self postNewMessge:messageToSend];
    }
    else {
        if(_group.participantsArray.count > 1) {
            //        g.participants = @[_user.username,
            Group *newGroup = [[AppDataSource sharedInstance] createNewGroup:_group];
            [messageToSend setGroupId:newGroup.groupId];
            messageToSend = [self postNewMessge:messageToSend];
        }
    }
    if(messageToSend.groupId && messageToSend.creationDate) {
        [_group.messages addObject:messageToSend];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_group.messages.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSInteger *rowToScrollTo = _group.messages.count-1;
//        if(rowToScrollTo < 1)
//            rowToScrollTo = 1;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowToScrollTo inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else {
        UIAlertView *comingSoonAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Oops :-(" message:@"Something went wrong. Your message was not sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [comingSoonAlert show];
        [_sendMessageTextField setText:messageToSend.messageText];
        
    }
}

- (User *)messageRecipient:(NSArray *)participants {
    NSString *currentUserUsername = _user.username;
    for (User *user in participants) {
        if(![user.username isEqualToString:currentUserUsername])
            return user;break;
    }
    return nil;
}

- (Message *)postNewMessge:(Message *)messageToSend {
    Message *messageSent = messageToSend;
    [[AppDataSource sharedInstance] postNewMessage:messageToSend withCompletion:^(Message *m, NSError *err) {
        [messageSent setMessageId:m.messageId];
        [messageSent setCreationDate:m.creationDate];
        [messageSent setSeenByParticipants:m.seenByParticipants];
    }];
    return messageSent;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _group.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    Message *message = _group.messages[indexPath.row];
    
    if(message) {
        
        if([_user.username isEqualToString:message.sender]) {
            // user sent this message
            cell = [tableView dequeueReusableCellWithIdentifier:sentTextCellIdentifier];
            
            if (cell == nil)
                cell = [[SentTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sentTextCellIdentifier];
            
        }
        else {
            // user received this message
            cell = [tableView dequeueReusableCellWithIdentifier:receivedTextCellIdentifier];
            
            if (cell == nil)
                cell = [[ReceivedTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:receivedTextCellIdentifier];
            
        }
        
        
        
        // Configure the cell...
        //    [cell setUserInteractionEnabled:NO];
        [cell setText:[_group.messages[indexPath.row] valueForKey:@"messageText"]];

    }
    
    return cell;
}




#pragma mark - Keyboard

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
}



// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
//    _insets = UIEdgeInsetsMake(self.tableView.contentInset.top, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    self.tableView.contentInset = contentInsets;
    
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    // Your app might not need or want this behavior.
    
//    CGRect aRect = self.view.frame;
    
//    aRect.size.height -= kbSize.height;
    
//    if (!CGRectContainsPoint(aRect, _sendMessageTextField.frame.origin) ) {
    
//        [self.tableView scrollRectToVisible:_sendMessageTextField.frame animated:YES];
    
//    }
    
    [_composeView setFrame:CGRectMake(_composeView.frame.origin.x, _composeView.frame.origin.y -kbSize.height, _composeView.frame.size.width, _composeView.frame.size.height)];
    
}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height +22, 0.0, 0.0, 0.0);
    
    self.tableView.contentInset = contentInsets;
    
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    [_composeView setFrame:CGRectMake(_composeView.frame.origin.x, self.view.frame.size.height - _composeView.frame.size.height, _composeView.frame.size.width, _composeView.frame.size.height)];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end




//- (void)keyboardDidShow:(NSNotification *)aNotification;
//{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.3f];
//    self.tableView.frame = CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height - 255); // or -216
//    [UIView commitAnimations];
//}
//
//- (void)keyboardDidHide:(NSNotification *)aNotification;
//{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.2f];
//    self.tableView.frame = CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height - 300);
//    [UIView commitAnimations];
//}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    CGRect rc = [textField bounds];
//    rc = [textField convertRect:rc toView:self.tableView];
//    CGPoint pt = rc.origin;
//    pt.x = 0;
//    if(rc.origin.y > 200)
//        pt.y -=  150;
//        else
//            pt.y -= rc.origin.y;
//            [self.tableView setContentOffset:pt animated:YES];
//    
//    return YES;
//}


//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField { // todo: make it work!
//    //    [UIView animateWithDuration:0
//    //                          delay:0
//    //                        options:UIViewAnimationOptionBeginFromCurrentState
//    //                     animations:^{
//    //                         _composeView.frame = CGRectMake(_composeView.frame.origin.x, _composeView.frame.origin.y - 300, _composeView.frame.size.width, _composeView.frame.size.height);
//    //                     }
//    //                     completion:nil];
//}
//

