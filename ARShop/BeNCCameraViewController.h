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
    NSMutableArray *shopsArray;
    CLLocation *userLocation ;
    NSMutableArray *arrayShopDistance;
    NSMutableArray *mutableArray;
    NSMutableArray *arrayTest;
}
- (void)addVideoInput;
- (NSMutableArray * )sortShopByDistance:(NSMutableArray *)array;
@end
