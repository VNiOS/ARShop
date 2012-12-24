//
//  BeNCDetailInCameraViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeNCShopEntity.h"
#include <CoreMotion/CoreMotion.h>
#import "BeNCArrow.h"
#import "BeNCDetailShopInCamera.h"
#import <CoreLocation/CoreLocation.h>

@interface BeNCDetailInCameraViewController : UIViewController{
    CMMotionManager *motionManager;
    BeNCArrow *arrowImage;
    NSTimer *timer;
    BeNCDetailShopInCamera *detailShop;
    CLLocation *userLocation;
    BeNCShopEntity *shop;
}
@property(nonatomic, retain)BeNCShopEntity *shop;
- (void)setContentForView:(BeNCShopEntity *)shopEntity;
- (void)updateContentForView:(BeNCShopEntity *)shopEntity;

@end
