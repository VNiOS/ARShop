//
//  BeNCShopCellCell.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BeNCShopCellCell;
@protocol BeNCShopCellDelegate <NSObject>

@optional
- (void)bnShoptCellDidClickedAtCell:(BeNCShopCellCell *)shopCell;
@end

@interface BeNCShopCellCell : UITableViewCell{
    UIButton *distanceToShop;
}
@property (nonatomic, retain) id<BeNCShopCellDelegate>delegate;
@property (nonatomic ,retain) UIButton *distanceToShop; 
@end
