//
//  MessagesTableViewController.m
//  Rand-iOS
//
//  Created by reuven on 9/29/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "UIColor+AppColors.h"
#import "UIImage+convertToColor.h"
//#import "Message.h"
#import "MessagesTableViewCell.h"
#import "AppGroup.h"
#import "InternalNavigationController.h"
#import "ContactsTableViewController.h"
#import "ConversationTableViewController.h"

@interface MessagesTableViewController ()

@end

@implementation MessagesTableViewController

static NSString * const MessagesTableViewCellIdentifier = @"Cell";

- (void)loadView {
    [super loadView];
    
    if(!_user)
        [self dismissViewControllerAnimated:NO completion:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *headerImage = [UIImage imageNamed:@"navHeaderImage"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerImage.size.width/2, 27)];
    [headerImageView setImage:headerImage];
    self.navigationItem.titleView = headerImageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MessagesTableViewCell class] forCellReuseIdentifier:MessagesTableViewCellIdentifier];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [leftSwipe setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftSwipe];
    
    // Uncomment the following line to preserve selection between presentations.
//    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    UIImage *leftButtonImage = [[UIImage imageNamed:@"menuIconMenu.png"] convertToColor:[UIColor themePrimaryColor]];
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
//    leftButton.frame = CGRectMake(0.0, 0.0, leftButtonImage.size.width, leftButtonImage.size.height);
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    [leftButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIImage *rightButtonImage = [[UIImage imageNamed:@"menuIconCompose@2x.png"] convertToColor:[UIColor themePrimaryColor]];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:rightButtonImage forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0.0, 0.0, rightButtonImage.size.width, rightButtonImage.size.height);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(leftSwipe) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
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
    [self.tabBarController setSelectedViewController:self.tabBarController.viewControllers[1]];
}

- (void)initCompose {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSString *)getGroupNameForGroup:(Group *)group {
//    // todo: find the username of the other participant (not currentuser)
//    return group.name;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppGroup *group = _groups[indexPath.row];
    
    MessagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessagesTableViewCellIdentifier];
    
    if (cell == nil)
        cell = [[MessagesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessagesTableViewCellIdentifier];
        
    if(group.messages.count > 0) {
        AppMessage *m = group.messages[group.messages.count -1];
        
        for(UIView *eachView in [cell subviews])
            [eachView removeFromSuperview];
        
        UIImage *avatar;
        if(group.name) {
            for (AppParticipant *participant in group.participantsArray) {
                if ([group.name isEqualToString:participant.username])
                    avatar = participant.avatarImage;
            }
        }
        else {
            avatar = [UIImage imageNamed:@"avatarCurrentUser"];
        }
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [avatarImageView setImage:avatar];
        [cell addSubview:avatarImageView];
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(55, 0, self.view.frame.size.width -60, 22)];
        [lbl1 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
        [lbl1 setTextColor:[UIColor blackColor]];
        lbl1.text = group.name;
        [cell addSubview:lbl1];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(55, 22, self.view.frame.size.width -60, 22)];
        [lbl2 setFont:[UIFont fontWithName:@"FontName" size:10.0]];
        [lbl2 setTextColor:[UIColor grayColor]];
        lbl2.text = m.messageText;
        [cell addSubview:lbl2];
        
        [cell setGroup:group];
        
//        [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height *2)];
        
        return cell;
    }
    else {
        return cell;
    }
}


















// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self presentGroupConversationViewController:_groups[indexPath.row]];
    [self presentGroupConversationTableViewController:_groups[indexPath.row]];
}

- (void)presentGroupConversationTableViewController:(AppGroup *)group {
    ConversationTableViewController *conversationTableViewController = [[ConversationTableViewController alloc] init];
    [conversationTableViewController setGroup:group];
    conversationTableViewController.initialMessageIndex = group.messages.count-1;
    
    [conversationTableViewController setUser:_user];
    [conversationTableViewController setTitle:group.name];
    
    InternalNavigationController *navigationController = [[InternalNavigationController alloc] initWithRootViewController:conversationTableViewController];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:conversationTableViewController action:@selector(goBack)];
    
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [downSwipe setNumberOfTouchesRequired:1];
    [navigationController.view addGestureRecognizer:downSwipe];
    
    [self presentViewController:navigationController animated:YES completion:nil];
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
