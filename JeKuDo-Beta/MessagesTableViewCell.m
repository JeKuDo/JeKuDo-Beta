//
//  MessagesTableViewCell.m
//  Rand-iOS
//
//  Created by reuven on 10/1/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "MessagesTableViewCell.h"
#import "Group.h"

@implementation MessagesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)setGroup:(Group *)group {
//    [self.textLabel setText:group.name];
//    [self setImage:[UIImage imageNamed:@"avatarCurrentUser.png"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
