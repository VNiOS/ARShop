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
#import "BeNCShopEntity.h"
#import "BeNCDetailInCamera.h"
@interface BeNCAR3DViewController : UIViewController{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
    NSMutableArray *shopsArray;
    NSMutableArray *shopInViewAngle;
    NSMutableArray *distanceToShop;
    CLLocation *userLocation ;
}
@property (nonatomic, retain)CLLocation *userLocation;
@property(nonatomic, retain) NSMutableArray *shopsArray;
@property(nonatomic, retain) NSMutableArray *shopInViewAngle;
- (void)addVideoInput;
-(void)getDatabase;
- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity;
-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity;
-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth;
//- (void)sortShopByDistance;
-(void)setContentForView;
-(void)calculateValueDistanceToShop;

@end
