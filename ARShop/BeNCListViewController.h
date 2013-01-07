//
//  BeNCListViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCShopEntity.h"
#import "BeNCShopCellCell.h"
@interface BeNCListViewController : UIViewController<BeNCShopCellDelegate>{
    
    int listType;
    
    IBOutlet UITableView *listShopView;
    NSMutableArray *shopsArray;
    CLLocation *userLocation ;
    float distanceToShop;
}
@property float distanceToShop;
@property(nonatomic,retain)IBOutlet UITableView *listShopView;
@property(nonatomic,retain)CLLocation *userLocation ;
@property(nonatomic) int listType;
-(void)didUpdateLocation:(NSNotification *)notifi;
-(void)getShopData;
-(int)calculeDistance:(BeNCShopEntity *)shop;
- (void)sortShopByCheckShop;
-(void)getShopDataFromMap:(NSArray *)shopArray;
-(void)sortShopByDistance;
@end
