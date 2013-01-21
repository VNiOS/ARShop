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
- (void)didSeclectView:(int )index;
@end
@interface BeNCDetailInCameraViewController : UIViewController<BeNCDetailShopDelegate,UIGestureRecognizerDelegate>{
    CMMotionManager *motionManager;
    BeNCArrow *arrowImage;
    NSTimer *timer;
    BeNCDetailShopInCamera *detailShop;
    CLLocation *userLocation;
    BeNCShopEntity *shop;
    int index;
    NSString *distanceToShop;
}
@property int index;
@property(nonatomic, retain)CLLocation *userLocation;
@property(nonatomic, retain)id<BeNCDetailInCameraDelegate>delegate;
@property(nonatomic, retain)BeNCShopEntity *shop;
- (id)initWithShop:(BeNCShopEntity *)shopEntity;
- (void)setContentForView:(BeNCShopEntity *)shopEntity;
-(float)calculateSizeFrame:(BeNCShopEntity *)shopEntity;
- (float)caculateMax:(float )numberA withNumberB:(float )numberB;

@end
