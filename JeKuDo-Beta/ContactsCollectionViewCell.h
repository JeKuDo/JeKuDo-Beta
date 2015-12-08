//
//  ContactsCollectionViewCell.h
//  Rand-iOS
//
//  Created by reuven on 11/17/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

@interface ContactsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Group *group;

- (void)setGroup:(Group *)group;

@end
