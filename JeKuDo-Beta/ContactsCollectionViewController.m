//
//  ContactsCollectionViewController.m
//  Rand-iOS
//
//  Created by reuven on 11/11/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "ContactsCollectionViewController.h"
#import "ContactsCollectionViewCell.h"
#import "AppDataSource.h"
//#import "AppParticipant.h"
#import "AppGroup.h"
#import "ConversationTableViewController.h"
#import "InternalNavigationController.h"
#import "GroupAvatarGenerator.h"


@interface ContactsCollectionViewController ()

//@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIRefreshControl *refreshControl;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;

@end

@implementation ContactsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

-(id) initWithUsers:(NSArray *)users {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:20.0f];
    [layout setMinimumLineSpacing:25.0f];
//    [layout setItemSize:CGSizeMake(120, 145)];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    if (self = [super initWithCollectionViewLayout:layout]) {
        _users= [[NSArray alloc] initWithArray:users];
        [[AppDataSource sharedInstance] fetchCurrentUserWithCompletion:^(User *user, NSError *err) {
            if(user)
                _currentUser = user;
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    UIImage *headerImage = [UIImage imageNamed:@"navHeaderImage"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerImage.size.width/2, 27)];
    [headerImageView setImage:headerImage];
    self.navigationItem.titleView = headerImageView;
    
    
    if(!_users)
        _users = [[AppDataSource sharedInstance] fetchUsersByUsernames:nil excludeCurrentUser:YES];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, GLPTabBarController.tabBarHeight, 0);
//    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, GLPTabBarController.tabBarHeight, 0);
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView registerClass:[ContactsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    [self.view addSubview:collectionView];
//    self.collectionView = collectionView;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshGroups) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.refreshControl = refreshControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







//- (void)presentGroupConversationTableViewController:(id)sender {
//    [[AppDataSource sharedInstance] fetchCurrentUserWithCompletion:^(User *sender, NSError *err) {
//        UIButton *s = sender;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[s tag] inSection:0];
//        User *user = _users[indexPath.row];
//        ConversationTableViewController *conversationTableViewController = [[ConversationTableViewController alloc] init];
//        //    conversationTableViewController.group = group;
//        Group *group = [[Group alloc] init];
//        [group setParticipants:@[user.username, sender.username]];
//        [conversationTableViewController setGroup:group];
//        
//        [conversationTableViewController setUser:user];
//        [conversationTableViewController setTitle:user.username];
//        
//        InternalNavigationController *navigationController = [[InternalNavigationController alloc] initWithRootViewController:conversationTableViewController];
//        
//        UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:conversationTableViewController action:@selector(goBack)];
//        //
//        [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
//        [downSwipe setNumberOfTouchesRequired:1];
//        [navigationController.view addGestureRecognizer:downSwipe];
//        
//        
//        
//        [self presentViewController:navigationController animated:YES completion:nil];
//        
//        //    [self.navigationController presentViewController:conversationTableViewController animated:YES completion:nil];
//        
//        //    [[AppDelegate sharedInstance] changeRootViewController:conversationTableViewController animated:YES];
//        
//    }];
//}



- (void)presentGroupConversationTableViewController:(AppGroup *)appGroup {
    ConversationTableViewController *conversationTableViewController = [[ConversationTableViewController alloc] init];
    [conversationTableViewController setGroup:appGroup];
    long messageIndex = appGroup.messages.count;
    if (messageIndex > 0)
        messageIndex--;
    conversationTableViewController.initialMessageIndex = messageIndex;
    
    [conversationTableViewController setUser:_currentUser];
    [conversationTableViewController setTitle:appGroup.name];
    
    InternalNavigationController *navigationController = [[InternalNavigationController alloc] initWithRootViewController:conversationTableViewController];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:conversationTableViewController action:@selector(goBack)];
    
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [downSwipe setNumberOfTouchesRequired:1];
    [navigationController.view addGestureRecognizer:downSwipe];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.users.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ContactsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
        cell = [[ContactsCollectionViewCell alloc] init];
    
    [cell setRestorationIdentifier:reuseIdentifier];
    
    // create/retrieve group for user
    AppGroup *appGroup = [[AppGroup alloc] init];
    AppParticipant *otherUser = _users[indexPath.row];
    NSMutableArray *participants = [[NSMutableArray alloc] init];
    [participants addObject:_currentUser];
    [participants addObject:otherUser];
    [appGroup setParticipantsArray:participants];
    
    appGroup = [[AppDataSource sharedInstance] createNewGroup:appGroup];
    [appGroup setName:otherUser.username];
    [cell setGroup:appGroup];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    NSUInteger itemsPerRow = 3;
    UIEdgeInsets sectionInset = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    CGFloat width = (self.view.bounds.size.width - sectionInset.left - sectionInset.right - flowLayout.minimumInteritemSpacing * (itemsPerRow - 1))/itemsPerRow;
    return CGSizeMake(width, 1.2 * width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat margins = (self.view.bounds.size.width > 320 ? 22 : 20);
    return UIEdgeInsetsMake(30, margins, 30, margins);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    Group *group = [[Group alloc] init];
//    Participant *otherUser = _users[indexPath.row];
//    NSMutableArray *participants = [[NSMutableArray alloc] init];
//    [participants addObject:_currentUser];
//    [participants addObject:otherUser];
//    [group setParticipants:participants];
    
//    group = [[AppDataSource sharedInstance] createNewGroup:group];
//    [group setName:otherUser.username];
//    [group setMessages:[[AppDataSource sharedInstance]
//    [self presentGroupConversationTableViewController:group];
//    ConversationTableViewController *conversationViewController = [[ConversationTableViewController alloc] init];
//    conversationViewController.group = group;
//    [self.navigationController pushViewController:conversationViewController animated:YES];
    
    
//    GLPPhotoGridViewController *photoGridController = [[GLPPhotoGridViewController alloc] initWithGroup:group];
//    [self.navigationController pushViewController:photoGridController animated:YES];
    
    User *selectedParticipant = _users[indexPath.row];
    AppGroup *group = [[AppDataSource sharedInstance] fetchDMGroupWithParticipant:selectedParticipant];
    [group setName:selectedParticipant.username];
    [self presentGroupConversationTableViewController:group];
    
}



//#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return _users.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    User *user = _users[indexPath.row];
//    
//    if (cell == nil) {
//        cell = [[ContactsCollectionViewCell alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 120, 145)];
//        [cell setRestorationIdentifier:reuseIdentifier];
//    }
//    
////    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 120, 145)];
//    
//    // Configure the cell
//    
//    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 120, 25)];
//    [cellLabel setText:user.username];
//    [cellLabel setTextAlignment:NSTextAlignmentCenter];
//    [cell addSubview:cellLabel];
//    
//    
//    return cell;
//}
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
////    ContactsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    User *user = _users[indexPath.row];
//    
//    if (cell == nil) {
//        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 120, 145)];
//        [cell setRestorationIdentifier:reuseIdentifier];
//    }
//    
//    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 120, 145)];
//   
//    // Configure the cell
//    
////    [cell setUser:_users[indexPath.row]];
////    [cell setMessageCount:0];
////    [cell setCellWithUser:user withMessageCount:nil];
//
//    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 120, 25)];
//    [cellLabel setText:user.username];
//    [cellLabel setTextAlignment:NSTextAlignmentCenter];
//    [cell addSubview:cellLabel];
//    
//    UIImage *cellButtonImage = [UIImage imageNamed:@"avatarCurrentUser"];
//    
//    
//    CGSize size = CGSizeMake(300, 300);
//    UIGraphicsBeginImageContext(size);
//    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width/2] addClip];
//    [cellButtonImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
//
//    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    
//    UIButton *cellButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
//    
//    [cellButton setBackgroundImage:resultImage forState:UIControlStateNormal];
//    [cellButton setTag:indexPath.row];
//    [cellButton addTarget:self action:@selector(presentGroupConversationTableViewController:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:cellButton];
//    
//    
//    
//    
////    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.collectionView.frame.size.width/3, self.collectionView.frame.size.width/3 +45)];
//    
////    User *user = _users[indexPath.row];
////    if(user) {
////        if(user.avatarImage) {
//////            UIImageView *imageView = [[UIImageView alloc] initWithImage:user.avatarImage];
//////            [imageView setFrame:CGRectMake(0, 0, 60, 60)];
//////            [cell addSubview:imageView];
////            UIButton *button = [[UIButton alloc] initWithFrame:cell.frame];
////            [button setBackgroundImage:user.avatarImage forState:UIControlStateNormal];
//////            [cell addSubview:button];
////            
////            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y + self.collectionView.frame.size.height/3, self.collectionView.frame.size.width/3, 45)];
////            [label setText:user.username];
////            [cell addSubview:label];
////        }
////        else {
//////            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatarCurrentUser"]];
//////            [cell addSubview:imageView];
////            UIButton *button = [[UIButton alloc] initWithFrame:cell.frame];
////            [button setBackgroundImage:[UIImage imageNamed:@"avatarCurrentUser"] forState:UIControlStateNormal];
////            [cell addSubview:button];
////        }
////    }
//
//    
//    return cell;
//}

//#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
