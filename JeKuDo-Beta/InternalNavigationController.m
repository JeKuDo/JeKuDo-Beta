//
//  InternalNavigationController.m
//  Rand-iOS
//
//  Created by reuven on 10/14/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "InternalNavigationController.h"
#import "UIColor+AppColors.h"

@interface InternalNavigationController ()

@end

@implementation InternalNavigationController

+ (void)initialize {
    
    [[UINavigationBar appearanceWhenContainedIn:self, nil] setTintColor:[UIColor themePrimaryColor]];
    [[UINavigationBar appearanceWhenContainedIn:self, nil] setBarTintColor:[UIColor themeLightBackgroundColor]];
    [[UINavigationBar appearanceWhenContainedIn:self, nil] setTitleTextAttributes:@{
                                                                                    NSForegroundColorAttributeName: [UIColor themePrimaryColor],
                                                                                    NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f]
                                                                                    }];
    
    [[UIBarButtonItem appearanceWhenContainedIn:self, nil] setTitleTextAttributes:@{
                                                                                    NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:17.0f]
                                                                                    } forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
