//
//  SentTextTableViewCell.m
//  Rand-iOS
//
//  Created by reuven on 10/14/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "SentTextTableViewCell.h"

@implementation SentTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self setBackgroundColor:[UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:249.0f/255.0f alpha:1]];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
