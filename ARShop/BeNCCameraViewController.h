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
<<<<<<< HEAD
    NSMutableArray *arrayShopDistance;
    NSMutableArray *mutableArray;
    NSMutableArray *arrayTest;
=======
>>>>>>> b7bdc2a6cee1c6733870a669a50850ebf59fc417
}
- (void)addVideoInput;
- (NSMutableArray * )sortShopByDistance:(NSMutableArray *)array;
@end
