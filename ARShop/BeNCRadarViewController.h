//
//  BeNCRadarViewController.h
//  ARShop
//
//  Created by Administrator on 1/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCShopEntity.h"

@interface BeNCRadarViewController : UIViewController{
    NSMutableArray *shopArray;
    CLLocation *userLocation;
}
@property (nonatomic, retain)NSMutableArray *shopArray;
@property (nonatomic, retain) CLLocation *userLocation;
- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity;
-(void)setcontentForView;

@end
