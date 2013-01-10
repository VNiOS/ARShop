//
//  BeNCOneShopARViewController.m
//  ARShop
//
//  Created by Administrator on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCOneShopARViewController.h"
#import "BeNCShopEntity.h"
#import "BeNCDetailInCameraViewController.h"
#import "LocationService.h"
#import <math.h>
#define rotationRate 0.0174532925
#define frameRadius 60

@interface BeNCOneShopARViewController ()

@end

@implementation BeNCOneShopARViewController
@synthesize userLocation,shop,rotationAngleArrow;

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        shop = shopEntity;
        self.userLocation = [[LocationService sharedLocation]getOldLocation]; 
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        [self setContentForView:shopEntity];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [self addVideoInput];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)addVideoInput {
    captureSession = [[AVCaptureSession alloc]init];
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = CGRectMake(0, 0, 480, 320);
    [previewLayer setOrientation:AVCaptureVideoOrientationLandscapeRight];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[self.view.layer addSublayer:previewLayer];
    NSError *error = nil;
    AVCaptureDevice * camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
    if ([captureSession canAddInput:deviceInput])
        [captureSession addInput:deviceInput];
    [captureSession startRunning];    
}
- (void)setContentForView:(BeNCShopEntity *)shopEntity
{
    detailView = [[BeNCDetailInCameraViewController alloc]initWithNibName:@"BeNCDetailInCameraViewController" bundle:nil];
    [detailView setContentForView:shopEntity];
    detailView.view.center = CGPointMake(240, 125);
    [self.view addSubview:detailView.view];
}
- (void)setNewCenterForView:(float )angleToHeading{
    float angle1 = atanf(85.0/240.0);
    float angle2 = M_PI - angle1;
    float angle3 = M_PI + angle1;
    float angle4 = 2 * M_PI - angle1;
    NSLog(@"goc 4 la %f",angle4);
    float a;
    if (angleToHeading < M_PI) {
        a = tan(angleToHeading);
    }
    else {
        a = tan(angleToHeading - M_PI);
    }
    float b = 125 - 240 * a ;
    float valueX = 240 ;
    float valueY = 125;
    if (0 <= angleToHeading < angle1 || angle4 <= angleToHeading < 2 * M_PI) {
        valueX = 100;
        valueY = 30 * a + b;
   
    }
        else if (angle1 <= angleToHeading < angle2){
            valueX = -b/a ;
            valueY = 80;
        }
        else if (angle2 <= angleToHeading < angle3) {
            valueX = 380;
            valueY = 480 * a + b;
        }
        else if (angle3 <= angleToHeading <  angle4) {
            valueX = ( 290 -b )/a;
            valueY = 230;
        }
    CGPoint newCenter = CGPointMake(valueX, valueY);
    detailView.view.center = newCenter;
    NSLog(@"center : %f , %f",newCenter.x,newCenter.y);
//    int valueX = 5 ;
//    int valueY = 160;
//    NSLog(@"goc quay cua heading so voi north la %f",angleToNorth);
//    int newX = (int)(detailView.view.center.x - valueX);
//    
//    if (newX > 460 - 50)
//        newX = 460 - 50;
//    
//    if (newX < 0 + 50)
//        newX = 0 + 50;
//    
//    int newY = (int)(detailView.view.center.y + valueY);
//    
//    if (newY > 300 - frameRadius) {
//        newY = 300 - frameRadius;
//    }
//    if (newY < 0 + frameRadius) {
//        newY = 0 + frameRadius;
//    }
//    
//    CGPoint newCenter = CGPointMake(newX, newY);
//    detailView.view.center = newCenter;

    

}

-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
    float angleToHeading;
    double angleToNorth =   newHeading.magneticHeading * rotationRate ;
    if (rotationAngleArrow > 0) {
        angleToHeading = ABS(rotationAngleArrow - angleToNorth);
    }
    else {
        
        angleToHeading = ABS(2 * M_PI - (angleToNorth - rotationAngleArrow));
    }
//    [self setNewCenterForView:angleToHeading];
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    rotationAngleArrow = [self caculateRotationAngle:shop];
}
-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity{
    CLLocation *shopLocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    CLLocationDistance distance = [shopLocation distanceFromLocation:userLocation];
    CLLocation *point =  [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:userLocation.coordinate.longitude];
    CLLocationDistance distance1 = [userLocation distanceFromLocation:point];
    double rotationAngle;
    
    double angle=acos(distance1/distance);
    if (userLocation.coordinate.latitude<=shopEntity.shop_latitude) {
        if (userLocation.coordinate.longitude<=shopEntity.shop_longitute) {
            rotationAngle = angle;
        }
        else{
            rotationAngle = - angle;
        }
    }
    else{
        if (userLocation.coordinate.longitude<shopEntity.shop_longitute) {
            rotationAngle = M_PI - angle;
        }
        else{
            rotationAngle = -(M_PI - angle);
        }
    }
    return rotationAngle;
}


@end
