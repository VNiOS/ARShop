//
//  BeNCAR3DViewController.m
//  ARShop
//
//  Created by Administrator on 1/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCAR3DViewController.h"
#import "LocationService.h"
#import "BeNCShopEntity.h"
#import "BeNCProcessDatabase.h"
#import "BeNCDetailInCameraViewController.h"
#define rotationRate 0.0174532925

@interface BeNCAR3DViewController ()

@end

@implementation BeNCAR3DViewController
@synthesize userLocation,shopsArray,shopInViewAngle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self getDatabase];
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [self setTitle:@"AR 3D"];
    self.view.bounds = CGRectMake(0, 0, 480, 320);        
    [self addVideoInput];
    shopInViewAngle = [[NSMutableArray alloc]init];
    distanceToShop = [[NSMutableArray alloc]init];
    [self calculateValueDistanceToShop];
    [super viewDidLoad];
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
-(void)getDatabase{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    shopsArray = [[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
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
- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute]autorelease];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
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

-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth
{
    float angleToHeading;
    if (angleToShop >= 0) {
        angleToHeading = angleToShop - angleToNorth;
        if (angleToHeading < - M_PI) {
            angleToHeading = 2 * M_PI - (angleToNorth - angleToShop);
        }
    }
    else if (angleToShop < 0){
        angleToHeading =  angleToShop - angleToNorth;
        
        if ( angleToHeading < - M_PI) {
            angleToHeading = 2 * M_PI + angleToHeading;
        }
    }
    return angleToHeading;
}

//- (void)sortShopByDistance
//{
//    for (int i = 0; i < [shopInViewAngle count]; i ++) {
//        BeNCShopEntity *shop1 = (BeNCShopEntity *)[shopInViewAngle  objectAtIndex:i];
//        for (int j = i + 1; j < [shopsArray count]; j ++) {
//            BeNCShopEntity *shop2 = (BeNCShopEntity *)[shopInViewAngle  objectAtIndex:j];
//            if ([self caculateDistanceToShop:shop1] > [self caculateDistanceToShop:shop2]) 
//                [shopInViewAngle exchangeObjectAtIndex:i withObjectAtIndex:j];
//        }
//    }
//}
-(void)setContentForView
{
    for (int i = 0; i < [shopInViewAngle count]; i ++) {
        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopInViewAngle  objectAtIndex:i];
        BeNCDetailInCameraViewController *detailView = [[BeNCDetailInCameraViewController alloc]initWithShop:shopEntity];
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
//        [self.view addSubview:detailView.view];
    }
//    [shopTest release];
//    shopTest = [shopInViewAngle objectAtIndex:0];
//    NSLog(@"ten cua shop la %@",shopTest.shop_name);
}

-(void)calculateValueDistanceToShop
{
    for (int i =0; i < [shopsArray count]; i ++) {
        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
        float distanceToShop1 = [self caculateDistanceToShop:shopEntity];
        [distanceToShop addObject:[NSNumber numberWithFloat:distanceToShop1]];
    }
    
}
-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
    double newAngleToNorth = newHeading.magneticHeading * rotationRate ;
    [shopInViewAngle removeAllObjects];
    for (int i = 0; i < [shopsArray count]; i ++) {
        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
        float rotationAngle = [self caculateRotationAngle:shopEntity];
        float angleToHeading = [self caculateRotationAngleToHeading:rotationAngle withAngleTonorth:newAngleToNorth];
        if (M_PI_4 <= angleToHeading && angleToHeading <= M_PI - M_PI_4) {
            [shopInViewAngle addObject:shopEntity];
        }
    }
//    NSLog(@"so shop nam trong tam nhin la %d",[shopInViewAngle count]);
//     [self sortShopByDistance];
//    [self setContentForView];
}
-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [self calculateValueDistanceToShop];
}
@end
