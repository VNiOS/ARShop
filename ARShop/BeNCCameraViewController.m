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
@interface BeNCCameraViewController ()

@end

@implementation BeNCCameraViewController
@synthesize locationManager;

#pragma mark - View Cycle Life
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self addVideoInput];
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [self setTitle:@"AR"];
    [self getDatabase];
    self.locationManager = [[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager setDistanceFilter:3];
    [locationManager startUpdatingLocation];
    userLocation = nil;
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
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    shopsArray = [[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
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
    arrayShopDistance = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i ++) {
        BeNCDetailInCameraViewController *detailView = [[BeNCDetailInCameraViewController alloc]initWithNibName:@"BeNCDetailInCameraViewController" bundle:nil];
        detailView.delegate = self;
        [detailView setIndex:i];
        [arrayShopDistance addObject:detailView];
        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
        [detailView setContentForView:shopEntity];
        if (i < 3) {
            CGRect frame = detailView.view.frame;
            frame.origin.x =  5;
            frame.origin.y = 105 * (i % 3) + 5;
            detailView.view.frame = frame;
            
        }
        
        else if (i >=3 && i < 5 ) {
            CGRect frame = detailView.view.frame;
            frame.origin.x =  480 - frame.size.width -5;
            frame.origin.y = 105 * (i % 3) + 55;
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
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
- (void)dealloc
{
    [captureSession stopRunning];
    [captureSession release];
    [deviceInput release];
    [super dealloc];
}

@end
