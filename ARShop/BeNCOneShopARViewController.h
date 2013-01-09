//
//  BeNCOneShopARViewController.h
//  ARShop
//
//  Created by Administrator on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCShopEntity.h"
#import "BeNCDetailInCameraViewController.h"
@interface BeNCOneShopARViewController : UIViewController{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
    CLLocation *userLocation ;
    double rotationAngleArrow;
    BeNCShopEntity *shop;
    BeNCDetailInCameraViewController *detailView;
}
@property(nonatomic, retain)BeNCShopEntity *shop;
@property double rotationAngleArrow;
@property(nonatomic, retain) CLLocation *userLocation;
- (void)addVideoInput;
- (void)setContentForView:(BeNCShopEntity *)shopEntity;
- (id)initWithShop:(BeNCShopEntity *)shopEntity;


@end
