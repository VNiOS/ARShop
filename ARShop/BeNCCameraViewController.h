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

@interface BeNCCameraViewController : UIViewController{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
    NSArray *shopsArray;
    CLLocation *userLocation ;
    NSMutableArray *arrayShopDistance;

}
- (void)addVideoInput;

@end
