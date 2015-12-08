//
//  SettingsViewController.m
//  Rand-iOS
//
//  Created by reuven on 10/16/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIColor+AppColors.h"
#import "UIImage+convertToColor.h"
#import "AppDataSource.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *headerImage = [UIImage imageNamed:@"navHeaderImage"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerImage.size.width/2, 27)];
    [headerImageView setImage:headerImage];
    self.navigationItem.titleView = headerImageView;
    
    [_logoutButton addTarget:self action:@selector(comingSoon) forControlEvents:UIControlEventTouchUpInside];
    [_logoutButton setBackgroundImage:[[UIImage imageNamed:@"profile"] convertToColor:[UIColor themePrimaryColor]] forState:UIControlStateNormal];
    
    UIImage *rightButtonImage = [[UIImage imageNamed:@"menuIconLogout@2x.png"] convertToColor:[UIColor themePrimaryColor]];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:rightButtonImage forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0.0, 0.0, rightButtonImage.size.width, rightButtonImage.size.height);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
 
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [rightSwipe setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightSwipe];
}

- (void)rightSwipe {
    [self.tabBarController setSelectedViewController:self.tabBarController.viewControllers[1]];
}

- (void) comingSoon {
    UIAlertView *comingSoonAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Comming Soon" message:@"This feature is yet to be added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [comingSoonAlert show];
}
- (IBAction)TestMethod:(id)sender {
    [self comingSoon];
}

- (void) logout {
    [[AppDataSource sharedInstance] logOutCurrentUserWithCompletion:^(NSArray *a, NSError *e) {
//        [self dismissViewControllerAnimated:YES completion:nil];
        [[AppDelegate sharedInstance] changeRootViewController:nil animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
