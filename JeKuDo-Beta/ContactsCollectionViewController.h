//
//  ContactsCollectionViewController.h
//  Rand-iOS
//
//  Created by reuven on 11/11/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsCollectionViewController : UICollectionViewController

@property (nonatomic, retain) NSArray *users;

-(id) initWithUsers:(NSArray *)users;

@end
