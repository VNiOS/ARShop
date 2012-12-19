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
@interface BeNCCameraViewController ()

@end

@implementation BeNCCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{ 
    userLocation = [[CLLocation alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [self addVideoInput];
    [self setContentForView];
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

- (void)sortShopByDistance
{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    shopsArray = [[[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]]retain];
    for (int i = 0; i < [shopsArray count]; i ++) {
        for (int j = i + 1; j < [shopsArray count]; j ++) {
            if ([self caculateDistanceToShop:[shopsArray objectAtIndex:i]] > [self caculateDistanceToShop:[shopsArray objectAtIndex:j]]) 
                [shopsArray exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
}


- (void)setContentForView
{
    for (int i = 0; i < 7; i ++) {
        BeNCShopEntity *shop = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
        NSLog(@"shop name la : %@",shop.shop_name);
        BeNCDetailInCameraViewController *detailView = [[BeNCDetailInCameraViewController alloc]initWithNibName:@"BeNCDetailInCameraViewController" bundle:nil];
        CGRect frame = detailView.view.frame;
        frame.origin.x = 235 *( i / 4) + 5;
        frame.origin.y = 60 * (i % 4) + 5;
        detailView.view.frame = frame;
        [detailView setContentForView:shop];
        [self.view addSubview:detailView.view];    
    }
    BeNCShopEntity *shop = (BeNCShopEntity *)[shopsArray objectAtIndex:2];
    NSLog(@"shop name la : %@",shop.shop_name);
    BeNCDetailInCameraViewController *detailView = [[BeNCDetailInCameraViewController alloc]initWithNibName:@"BeNCDetailInCameraViewController" bundle:nil];
    CGRect frame = detailView.view.frame;
    frame.origin.x =  5;
    frame.origin.y =  5;
    detailView.view.frame = frame;
    [detailView setContentForView:shop];
    [self.view addSubview:detailView.view]; 

}


- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    int distance = (int)[shoplocation distanceFromLocation: userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [self sortShopByDistance];
}

- (void)dealloc
{
    [captureSession stopRunning];
    [captureSession release];
    [deviceInput release];
    [super dealloc];
}

@end
