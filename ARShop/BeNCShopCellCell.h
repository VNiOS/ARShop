//
//  BeNCShopCellCell.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCShopEntity.h"
#import "EGOImageView.h"
@class BeNCShopCellCell;
@protocol BeNCShopCellDelegate <NSObject>

@optional
- (void)bnShoptCellDidClickedAtCell:(BeNCShopCellCell *)shopCell;
- (void)beNCShopCellDidCleckCheckButton:(BeNCShopCellCell *)shopCell;
@end

@interface BeNCShopCellCell : UITableViewCell{
    UIButton *checkbox ;
    UIButton *distanceToShop;
    EGOImageView *icon ;
    CLLocation *userLocation ;

}
@property (nonatomic,retain) EGOImageView *icon;
@property (nonatomic, retain)CLLocation *userLocation ;
@property (nonatomic, retain) id<BeNCShopCellDelegate>delegate;
@property (nonatomic ,retain) UIButton *distanceToShop;
- (void)updateContentForCell:(BeNCShopEntity *)shopEntity withLocation:(CLLocation *)location;
@end
