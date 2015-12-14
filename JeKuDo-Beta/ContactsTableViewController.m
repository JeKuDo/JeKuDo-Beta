//
//  ContactsTableViewController.m
//  Rand-iOS
//
//  Created by reuven on 9/11/15.
//  Copyright (c) 2015 JeKuDo. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ConversationTableViewController.h"
#import "InternalNavigationController.h"
#import "AppDataSource.h"
#import "User.h"
#import "AppDelegate.h"

@interface ContactsTableViewController ()

@end

@implementation ContactsTableViewController

static NSString * const ContactsTableViewCellIdentifier = @"Cell";

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *headerImage = [UIImage imageNamed:@"navHeaderImage"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerImage.size.width/2, 27)];
    [headerImageView setImage:headerImage];
    self.navigationItem.titleView = headerImageView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView registerClass:[ContactsTableViewCellIdentifier class] forCellReuseIdentifier:ContactsTableViewCellIdentifier];
    
    if(!_users)
        _users = [[AppDataSource sharedInstance] fetchUsersByUsernames:nil excludeCurrentUser:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [leftSwipe setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftSwipe];

    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [rightSwipe setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightSwipe];
    
    // Uncomment the following line to preserve selection between presentations.
//    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView registerClass:[MessagesTableViewCell class] forCellReuseIdentifier:MessagesTableViewCellIdentifier];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
}

- (void)refresh {
    NSLog(@"refresh");
    [self.refreshControl endRefreshing];
}

- (void)leftSwipe {
    [self.tabBarController setSelectedViewController:self.tabBarController.viewControllers[2]];
}

- (void)rightSwipe {
    [self.tabBarController setSelectedViewController:self.tabBarController.viewControllers[0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _users.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *title = [NSString stringWithFormat:@"Recent Contacts"];
//    if(section == 1)
//        title = @"All Contacts";
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // todo: we're not reusing the cell, we alloc init. fix!
    
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactsTableViewCellIdentifier forIndexPath:indexPath];
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContactsTableViewCellIdentifier];
//    
    // Configure the cell...

//    [cell.textLabel setText:[NSString stringWithFormat:@"user%d",indexPath]];
//    [cell setImage:[UIImage imageNamed:@"avatarCurrentUser"]];
    User *user = _users[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactsTableViewCellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContactsTableViewCellIdentifier];
    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContactsTableViewCellIdentifier];
    
    
    
    [cell.textLabel setText:user.username];
    [cell setImage:[UIImage imageNamed:@"avatarCurrentUser"]];
//    [cell setImage:user.avatarImage];
    return cell;
}

//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 6;
//    
//}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
//}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self presentGroupConversationTableViewController:_users[indexPath.row]];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




- (void)presentGroupConversationTableViewController:(User *)user {
    [[AppDataSource sharedInstance] fetchCurrentUserWithCompletion:^(User *sender, NSError *err) {

        ConversationTableViewController *conversationTableViewController = [[ConversationTableViewController alloc] init];
        //    conversationTableViewController.group = group;
        AppGroup *group = [[AppGroup alloc] init];
        [group setParticipantsArray:@[user.username, sender.username]];
        [conversationTableViewController setGroup:group];
        
        [conversationTableViewController setUser:user];
        [conversationTableViewController setTitle:user.username];
        
        InternalNavigationController *navigationController = [[InternalNavigationController alloc] initWithRootViewController:conversationTableViewController];
        
        UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:conversationTableViewController action:@selector(goBack)];
        //
        [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
        [downSwipe setNumberOfTouchesRequired:1];
        [navigationController.view addGestureRecognizer:downSwipe];
        
        
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
        //    [self.navigationController presentViewController:conversationTableViewController animated:YES completion:nil];
        
        //    [[AppDelegate sharedInstance] changeRootViewController:conversationTableViewController animated:YES];
        
    }];
}


@end
