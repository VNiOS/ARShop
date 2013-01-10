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

@class BeNCListViewController;

@protocol ListViewOnMapDelegate 
-(void)animationScaleOff:(UINavigationController *)listview;  
@end



@interface BeNCListViewController : UIViewController<BeNCShopCellDelegate,UITableViewDelegate,UITableViewDataSource>{
        int listType;
    IBOutlet UITableView *listShopView;
    NSMutableArray *shopsArray;
    CLLocation *userLocation ;
    float distanceToShop;
    BOOL editing;
    UIBarButtonItem *editButton;
}
@property(nonatomic,strong) id<ListViewOnMapDelegate> delegate;

@property float distanceToShop;
@property(nonatomic,retain)IBOutlet UITableView *listShopView;
@property(nonatomic,retain)CLLocation *userLocation ;
@property(nonatomic) int listType;
-(void)didUpdateLocation:(NSNotification *)notifi;
-(void)getShopData;
-(int)calculeDistance:(BeNCShopEntity *)shop;
- (void)refreshData;
- (IBAction)editList:(id)sender;
-(void)getShopDataFromMap:(NSArray *)shopArray;
-(void)sortShopByDistance;
-(IBAction)closeListViewInMap:(id)sender;

@end
