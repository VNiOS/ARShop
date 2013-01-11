//
//  BeNCCameraViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCCameraViewController.h"
#import "LocationService.h"
#import "BeNCProcessDatabase.h"
#import "BeNCShopEntity.h"
#import "BeNCDetailInCameraViewController.h"
#import "BeNCDetailViewController.h"
#import "BeNCListViewController.h"
#define rotationRate 0.0174532925

@interface BeNCCameraViewController ()

@end

@implementation BeNCCameraViewController

#pragma mark - View Cycle Life
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userLocation = [[LocationService sharedLocation] getOldLocation];
        [self sortShopByDistance];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        [self addVideoInput];
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [self setTitle:@"AR"];
    [self getDatabase];
    self.view.bounds = CGRectMake(0, 0, 480, 320);
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


# pragma mark - add Video to App
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


# pragma mark - get Database
- (void )getDatabase
{
    BeNCListViewController *listViewController = [[BeNCListViewController alloc]initWithNibName:@"BeNCListViewController" bundle:nil];
    shopsArray = [[[NSMutableArray alloc]initWithArray:listViewController.shopsArray]retain];

}

- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    int distance = (int)[shoplocation distanceFromLocation: userLocation];
    return distance;
}


#pragma mark - set Content For View


- (void)setContentForView
{
    [arrayShopDistance release];
    arrayShopDistance = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i ++) {
        BeNCDetailInCameraViewController *detailView = [[BeNCDetailInCameraViewController alloc]initWithNibName:@"BeNCDetailInCameraViewController" bundle:nil];
        detailView.delegate = self;
        [detailView setIndex:i];
        [arrayShopDistance addObject:detailView];
        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
        [detailView setContentForView1:shopEntity];
        if (i < 3) {
            CGRect frame = detailView.view.frame;
            frame.origin.x =  5;
            frame.origin.y = 85 * (i % 3) + 5;
            detailView.view.frame = frame;
            
        }
        
        else if (i >=3 && i < 5 ) {
            CGRect frame = detailView.view.frame;
            frame.origin.x =  480 - frame.size.width -5;
            frame.origin.y = 103 * (i % 3) + 35;
            detailView.view.frame = frame;
        }
        [self.view addSubview:detailView.view];
        
    }
}
- (void)deleteData
{
    for (int i = 0; i < [arrayShopDistance count]; i ++) {
        BeNCDetailInCameraViewController *detailView = (BeNCDetailInCameraViewController *)[arrayShopDistance objectAtIndex:i];
        [detailView.view removeFromSuperview];
        [detailView release];
    }
    [self setContentForView];
}
- (void)sortShopByDistance
{
    for (int i = 0; i < [shopsArray count]; i ++) {
        for (int j = i + 1; j < [shopsArray count]; j ++) {
            if ([self caculateDistanceToShop:[shopsArray objectAtIndex:i]] > [self caculateDistanceToShop:[shopsArray objectAtIndex:j]]) 
                [shopsArray exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    [self deleteData];
}


-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [self sortShopByDistance];
}

- (void)didSeclectView:(int)index
{
    BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:index];
    BeNCDetailViewController *detailViewController = [[BeNCDetailViewController alloc] initWithShop:shopEntity];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)setNewCenterForView:(float )angleToHeading  withDetailView:(BeNCDetailInCameraViewController *)detailViewInCamera{
    float originX = detailViewInCamera.view.frame.size.width/2;
    float originY = detailViewInCamera.view.frame.size.height/2;
    float angle1 = atanf(125.0/240.0);
    float angle2 = M_PI - angle1;
    float a = tan(angleToHeading);
    float b = 125 - 240 * a ;
    float valueX ;
    float valueY;
    if ((0 <= angleToHeading && angleToHeading < angle1 )||( - angle1 <= angleToHeading && angleToHeading < 0)) {
        valueX = originX;
        valueY =  b;
    }
    else if (angle1 <= angleToHeading && angleToHeading< angle2){
        valueX =   - b / a ;
        valueY = originY;
    }
    else if ((angle2 <= angleToHeading && angleToHeading < M_PI) || (- M_PI <= angleToHeading && angleToHeading < - angle2)) {
        valueX = 480 - originX;
        valueY = 480 * a + b;
    }
    else if (- angle2 <= angleToHeading && angleToHeading <  - angle1) {
        valueX = ( 250 -b )/a;
        valueY = 300 - originY;
    }
    if (valueX <= originX) {
        valueX = originX;
    }
    if (valueX > 480 - originX ) {
        valueX = 480 - originX ;
    }
    if (valueY <= originY) {
        valueY = originY;
    }
    if (valueY > 300 - originY ) {
        valueY = 300 - originY;
    }
    CGPoint newCenter = CGPointMake(valueX, valueY);
    detailViewInCamera.view.center = newCenter;
    
}

//-(void)didUpdateHeading:(NSNotification *)notification{
//    CLHeading *newHeading = [notification object];
//    float angleToHeading;
//    double angleToNorth =   newHeading.magneticHeading * rotationRate ;
//    if (rotationAngleArrow >= 0) {
//        angleToHeading = rotationAngleArrow - angleToNorth;
//        if (angleToHeading < - M_PI) {
//            angleToHeading = 2 * M_PI - (angleToNorth - rotationAngleArrow);
//        }
//    }
//    else if (rotationAngleArrow < 0){
//        angleToHeading =  rotationAngleArrow - angleToNorth;
//        
//        if ( angleToHeading < - M_PI) {
//            angleToHeading = 2 * M_PI + angleToHeading;
//        }
//        
//    }
//    [self setNewCenterForView:angleToHeading];
//}

//-(void)didUpdateLocation:(NSNotification *)notification {
//    CLLocation *newLocation = (CLLocation *)[notification object];
//    [userLocation release];
//    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
//    rotationAngleArrow = [self caculateRotationAngle:shop];
//}

- (void)dealloc
{
    [captureSession stopRunning];
    [captureSession release];
    [deviceInput release];
    [super dealloc];
}

@end
