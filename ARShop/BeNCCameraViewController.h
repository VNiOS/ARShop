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
    CLLocationManager *locationManager;
}
@property(nonatomic, retain)CLLocationManager *locationManager;
- (void)addVideoInput;
@end
