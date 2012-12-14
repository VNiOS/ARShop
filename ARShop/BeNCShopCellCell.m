//
//  BeNCShopCellCell.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCShopCellCell.h"

@implementation BeNCShopCellCell
@synthesize distanceBt;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.distanceBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.distanceBt setFrame:CGRectMake(280, 5, 100, 50)];
        [self addSubview:self.distanceBt];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
