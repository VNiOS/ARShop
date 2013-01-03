//
//  BeNCShopCellCell.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCShopCellCell.h"

@implementation BeNCShopCellCell
@synthesize distanceToShop,delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIButton *checkboxButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [checkboxButton setTitle:@"Check" forState:UIControlStateNormal];
        [checkboxButton setFrame:CGRectMake(390, 5, 80, 50)];
        [checkboxButton addTarget:self action:@selector(touchesToButtonDistance) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkboxButton];
        
        distanceToShop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [distanceToShop setFrame:CGRectMake(290, 5, 90, 50)];
        [distanceToShop addTarget:self action:@selector(touchesToButtonDistance) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:distanceToShop];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)touchesToButtonDistance
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bnShoptCellDidClickedAtCell:)]) {
        [self.delegate bnShoptCellDidClickedAtCell:self];
    }
}

- (void)dealloc
{
    [distanceToShop release];
    [super dealloc];
}

@end
