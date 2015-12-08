//
//  ContactsCollectionViewCell.m
//  Rand-iOS
//
//  Created by reuven on 11/17/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "ContactsCollectionViewCell.h"
#import "AppDataSource.h"
#import "GroupAvatarGenerator.h"
#import "GroupBadgeLabel.h"
#import "User.h"

@interface ContactsCollectionViewCell ()

@property (nonatomic, weak) UILabel *titleLabel, *badgeLabel;
@property (nonatomic, weak) UIImageView *avatarImageView;

@end

@implementation ContactsCollectionViewCell

static void *GroupCellBadgeContext = &GroupCellBadgeContext;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:avatarImageView];
        self.avatarImageView = avatarImageView;
        
        CGFloat badgeHeight = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.08;
        GroupBadgeLabel *badgeLabel = [[GroupBadgeLabel alloc] init];
        badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:badgeLabel];
        self.badgeLabel = badgeLabel;
        
        NSDictionary *metrics = @{@"badge": @(badgeHeight)};
        NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel, avatarImageView, badgeLabel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[avatarImageView]-5-[titleLabel(20)]|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:avatarImageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[badgeLabel]-(-3)-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-3)-[badgeLabel(badge)]" options:0 metrics:metrics views:views]];
        
        [self addObserver:self forKeyPath:@"group.numberOfUnreadMessages" options:0 context:GroupCellBadgeContext];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"group.numberOfUnreadMessages" context:GroupCellBadgeContext];
}

- (void)setGroup:(Group *)group {
    _group = group;
    
//    [[AppDataSource sharedInstance] fetchCurrentUserWithCompletion:^(User *currentUser, NSError *err) {
    
        self.titleLabel.text = group.name;
        
        NSMutableArray *groupParticipants = [group.participants mutableCopy];
    
        for (Participant *participant in groupParticipants) {
            if ([participant.username isEqualToString: group.name]) {
//                [avatarImages addObject:participant.avatarImage];
                [[GroupAvatarGenerator sharedInstance] getAvatarImageForGroupName:group.name withAvatars:@[participant.avatarImage] withCompletionHandler:^(UIImage *avatarImage) {
                    [UIView transitionWithView:self.avatarImageView duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        NSLog(@"participant: %@", participant.username);
                        self.avatarImageView.image = avatarImage;
                    } completion:nil];
                }];
            }
        }
        
    
//    }];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [UIView animateWithDuration:0.2f animations:^{
        self.titleLabel.alpha = self.avatarImageView.alpha = (highlighted ? 0.6f : 1.0f);
    }];
}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == GroupCellBadgeContext) {
        self.badgeLabel.hidden = (self.group.numberOfUnreadMessages == 0);
        self.badgeLabel.text = [NSString stringWithFormat:@"%ld", self.group.numberOfUnreadMessages];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
