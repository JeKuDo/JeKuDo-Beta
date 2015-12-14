//
//  ContactsCollectionViewCell.h
//  Rand-iOS
//
//  Created by reuven on 11/17/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppGroup.h"

@interface ContactsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AppGroup *group;

- (void)setGroup:(AppGroup *)group;

@end
