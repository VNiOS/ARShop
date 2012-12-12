//
//  BeNCCameraViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>

@interface BeNCCameraViewController : UIViewController{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
}
- (void)addVideoInput;

@end
