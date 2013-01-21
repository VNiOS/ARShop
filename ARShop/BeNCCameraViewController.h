//
//  BeNCCameraViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCDetailInCameraViewController.h"

@interface BeNCCameraViewController : UIViewController<CLLocationManagerDelegate,BeNCDetailInCameraDelegate>{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
    NSMutableArray *shopsArray;
    CLLocation *userLocation ;
    NSMutableArray *arrayShopDistance;
    double rotationAngleArrow1;
    double rotationAngleArrow2;
    double rotationAngleArrow3;
    double rotationAngleArrow4;
    double rotationAngleArrow5;
    BeNCShopEntity *shopEntity1;
    BeNCShopEntity *shopEntity2;
    BeNCShopEntity *shopEntity3;
    BeNCShopEntity *shopEntity4;
    BeNCShopEntity *shopEntity5;
    BeNCDetailInCameraViewController *detaitlView1;
    BeNCDetailInCameraViewController *detaitlView2;
    BeNCDetailInCameraViewController *detaitlView3;
    BeNCDetailInCameraViewController *detaitlView4;
    BeNCDetailInCameraViewController *detaitlView5;
}
- (void)addVideoInput;
-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity;
- (void)setNewCenterForView:(float )angleToHeading  withDetailView:(BeNCDetailInCameraViewController *)detailViewInCamera;

@end
