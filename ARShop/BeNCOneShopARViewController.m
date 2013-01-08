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
    CGRect frame = detailView.view.frame;
    frame.origin.x = 25;
    frame.origin.y = 50;
    detailView.view.frame = frame;
    [self.view addSubview:detailView.view];
}
-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
    double angleToNorth =  - newHeading.magneticHeading * rotationRate - M_PI_2;
    double angleToHeading =   rotationAngleArrow + angleToNorth;
    int valueX = cos(angleToHeading) * 240 ;
    int valueY = sin(angleToHeading) * 160;
//    NSLog(@"valuex %d valuey %d",valueX,valueY);
    int newX = (int)(detailView.view.center.x - valueX);
    
    if (newX > 460 - frameRadius)
        newX = 460 - frameRadius;
    
    if (newX < 40 + frameRadius)
        newX = 40 + frameRadius;
    
    int newY = (int)(detailView.view.center.y-valueY);
    
    if (newY > 280 - frameRadius) {
        newY = 260 - frameRadius;
    }
    if (newY < 40 + frameRadius) {
        newY = 40 + frameRadius;
    }
    
    CGPoint newCenter = CGPointMake(newX, newY);
    //
    detailView.view.center = newCenter;
//    NSLog(@"goc cua mui ten so voi huong bac la %f",angleToHeading);
//    CGRect frame = detailView.view.frame;
//    int valueX = frame.origin.x + cosh(angleToHeading);
//    int valueY = frame.origin.y + sinh(angleToHeading);
//    if (valueX > 480-frameRadius)
//        valueX = 480-frameRadius;
//    
//    if (valueX < 0 )
//        valueX = 0 ;
//        
//    if (valueY > 300 - frameRadius) {
//        valueY = 300 - frameRadius;
//    }
//    if (valueX < 0 ) {
//        valueY = 0 ;
//    }
//    frame.origin.x = valueX;
//    frame.origin.y = valueY;
//
//    detailView.view.frame = frame;
//    CGAffineTransform tnansform = CGAffineTransformMakeTranslation(<#CGFloat tx#>, <#CGFloat ty#>)
    
//    int newX = (int)(bug.center.x + valueX);
//    
//    if (newX > 320-BALL_RADIUS)
//        newX = 320-BALL_RADIUS;
//    
//    if (newX < 0 + BALL_RADIUS)
//        newX = 0 + BALL_RADIUS;
//    
//    int newY = (int)(bug.center.y-valueY);
//    
//    if (newY > 460 - BALL_RADIUS) {
//        newY = 460 - BALL_RADIUS;
//    }
//    if (newY < 0 + BALL_RADIUS) {
//        newY = 0 + BALL_RADIUS;
//    }

    //self.transform = CGAffineTransformMakeRotation( - newHeading.magneticHeading * rotationRate - M_PI_2 + rotationAngleArrow);
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
