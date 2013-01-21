//
//  BeNCAR3DViewController.h
//  ARShop
//
//  Created by Administrator on 1/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BeNCAR3DViewController : UIViewController{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
    NSMutableArray *shopsArray;
    CLLocation *userLocation ;
    NSMutableArray *arrayShopDistance;
}
@property (nonatomic, retain)CLLocation *userLocation;


@end
