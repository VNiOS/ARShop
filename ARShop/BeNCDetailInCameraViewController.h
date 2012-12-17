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

@interface BeNCDetailInCameraViewController : UIViewController{
    CMMotionManager *motionManager;
    BeNCArrow *arrowImage;
    NSTimer *timer;
}
- (void)setContentForView:(BeNCShopEntity *)shopEntity;


@end
