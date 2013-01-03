//
//  BeNCShopCellCell.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCShopCellCell.h"

@implementation BeNCShopCellCell
@synthesize distanceToShop,delegate,checkBoxSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        checkBoxSelected = 1;
        checkbox = [[UIButton alloc] initWithFrame:CGRectMake(390,5,50,50)];
        [checkbox setBackgroundImage:[UIImage imageNamed:@"unchecked.png"]forState:UIControlStateNormal];
        [checkbox setBackgroundImage:[UIImage imageNamed:@"checkbox.png"]forState:UIControlStateSelected];
        [checkbox setBackgroundImage:[UIImage imageNamed:@"checkbox.png"]forState:UIControlStateHighlighted];
        checkbox.adjustsImageWhenHighlighted=YES;
        [checkbox setSelected:checkBoxSelected];
        [checkbox addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkbox];
        
        
        
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
            
-(void)checkboxSelected:(id)sender
{
    checkBoxSelected = !checkBoxSelected;
    [checkbox setSelected:checkBoxSelected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(beNCShopCellDidCleckCheckButton:)]) {
        [self.delegate beNCShopCellDidCleckCheckButton:self];
    }
}
- (void)dealloc
{
    [distanceToShop release];
    [super dealloc];
}

@end
