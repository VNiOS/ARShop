//
//  BeNCShopCellCell.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCShopCellCell.h"
#import "BeNCShopEntity.h"

@implementation BeNCShopCellCell
@synthesize distanceToShop,delegate,userLocation;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        distanceToShop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
- (void)updateContentForCell:(BeNCShopEntity *)shopEntity withLocation:(CLLocation *)location
{    
    [distanceToShop setFrame:CGRectMake(330, 5, 90, 50)];
    [distanceToShop addTarget:self action:@selector(touchesToButtonDistance) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:distanceToShop];
    self.textLabel.text = shopEntity.shop_name;
    self.detailTextLabel.text = shopEntity.shop_address;
    self.imageView.image = [UIImage imageNamed:@"images.jpg"];
    NSString *distanceShop = [NSString stringWithFormat:@"%d m",[self calculeDistance:shopEntity withLocation:location]];
    [self.distanceToShop setTitle:distanceShop forState:UIControlStateNormal];
}

-(int)calculeDistance:(BeNCShopEntity *)shop withLocation:(CLLocation *)location
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:shop.shop_latitude longitude:shop.shop_longitute];
    int distance = (int)[shoplocation distanceFromLocation:location];
    return distance;
}


//-(void)checkboxSelected:(id)sender
//{
//    checkBoxSelected = !checkBoxSelected;
//    [checkbox setSelected:checkBoxSelected];
////    if (self.delegate && [self.delegate respondsToSelector:@selector(beNCShopCellDidCleckCheckButton:)]) {
////        [self.delegate beNCShopCellDidCleckCheckButton:self];
////    }
//}
- (void)dealloc
{
    [distanceToShop release];
    [super dealloc];
}

@end
