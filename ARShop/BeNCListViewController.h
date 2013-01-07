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
@interface BeNCListViewController : UIViewController<BeNCShopCellDelegate,UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *listShopView;
    NSMutableArray *shopsArray;
    CLLocation *userLocation ;
    float distanceToShop;
    BOOL editing;
    UIBarButtonItem *editButton;
}
@property float distanceToShop;
@property(nonatomic,retain)IBOutlet UITableView *listShopView;
@property(nonatomic,retain)CLLocation *userLocation ;
-(void)didUpdateLocation:(NSNotification *)notifi;
-(void)getShopData;
-(int)calculeDistance:(BeNCShopEntity *)shop;
- (void)sortShopByCheckShop;
- (IBAction)editList:(id)sender;
@end
