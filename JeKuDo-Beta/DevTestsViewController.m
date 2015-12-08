//
//  DevTestsViewController.m
//  Rand-iOS
//
//  Created by reuven on 12/7/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "DevTestsViewController.h"
#import "AppDelegate.h"
#import "Group.h"
#import "SignUpViewController.h"
#import "EntryNavigationController.h"

@interface DevTestsViewController ()

@end

@implementation DevTestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)runAppButton:(id)sender {
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    EntryNavigationController *navigationController = [[EntryNavigationController alloc] initWithRootViewController:signUpViewController];
    [[AppDelegate sharedInstance] changeRootViewController:navigationController animated:YES];
}
- (IBAction)testCoreDataButton:(id)sender {
    [self testCoreData:YES];
}


- (void)testCoreData:(BOOL)runTest {
    if (runTest)
    {
        NSLog(@"%@",_managedObjectContext);
        NSManagedObject *newGroup = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Group"
                                     inManagedObjectContext:_managedObjectContext];
        [newGroup setValue:@"Test Group Name via Core Data" forKey:@"name"];
        
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        NSLog(@"completed testCoreData");
    }
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
