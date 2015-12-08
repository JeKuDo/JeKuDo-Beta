//
//  ReceivedTextTableViewCell.m
//  Rand-iOS
//
//  Created by reuven on 10/14/15.
//  Copyright © 2015 JeKuDo. All rights reserved.
//

#import "ReceivedTextTableViewCell.h"

@implementation ReceivedTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        
        
//        CGSize s = CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height);
//        self.contentView.frame.size.width = self.contentView.frame.size.width -45;
        [self.contentView setFrame:CGRectMake(45, 0, self.contentView.frame.size.width -45, self.contentView.frame.size.height)];
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
