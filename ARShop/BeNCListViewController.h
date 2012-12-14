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
@interface BeNCListViewController : UIViewController{
    IBOutlet UITableView *listShopView;
    NSArray *shopsArray;
    CLLocation *userLocation ;
}
@property(nonatomic,retain) IBOutlet UITableView *listShopView;
@property(nonatomic,retain)  CLLocation *userLocation ;

-(void)didUpdateLocation:(NSNotification *)notifi;
-(void)didUpdateHeading:(NSNotification *)notifi;
-(void)getShopData;
-(int)calculeDistance:(BeNCShopEntity *)shop;
@end
