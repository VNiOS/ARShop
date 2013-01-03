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
@class BeNCDetailInCameraViewController;
@protocol BeNCDetailInCameraDelegate <NSObject>

@optional
- (void)didSeclectView:(int )index;

@end
@interface BeNCDetailInCameraViewController : UIViewController<BeNCDetailShopDelegate>{
    CMMotionManager *motionManager;
    BeNCArrow *arrowImage;
    NSTimer *timer;
    BeNCDetailShopInCamera *detailShop;
    CLLocation *userLocation;
    BeNCShopEntity *shop;
    int index;
}
@property int index;
@property(nonatomic, retain)id<BeNCDetailInCameraDelegate>delegate;
@property(nonatomic, retain)BeNCShopEntity *shop;
- (void)setContentForView:(BeNCShopEntity *)shopEntity;

@end
