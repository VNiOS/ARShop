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

#pragma mark - View Cycle Life
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
    [self getDatabase];
    arrayTest = [[NSMutableArray alloc]init];
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

- (NSMutableArray * )sortShopByDistance:(NSMutableArray *)array
{
    for (int i = 0; i < [array count]; i ++) {
        BeNCShopEntity *shop1 = (BeNCShopEntity *)[array objectAtIndex:i];
        for (int j = i + 1; j < [array count]; j ++) {
            BeNCShopEntity *shop2 = (BeNCShopEntity *)[array objectAtIndex:j];
            if ([self caculateDistanceToShop:shop1] > [self caculateDistanceToShop:shop2]) 
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    return array;
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
    for (int i = 0; i < 5; i ++) {
        BeNCDetailInCameraViewController *detailView = [[BeNCDetailInCameraViewController alloc]initWithNibName:@"BeNCDetailInCameraViewController" bundle:nil];
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
//- (void)sortShopByDistance
//{
//    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
//    shopsArray = [[[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]]retain];
//    for (int i = 0; i < [shopsArray count]; i ++) {
//        for (int j = i + 1; j < [shopsArray count]; j ++) {
//            if ([self caculateDistanceToShop:[shopsArray objectAtIndex:i]] > [self caculateDistanceToShop:[shopsArray objectAtIndex:j]]) 
//                [shopsArray exchangeObjectAtIndex:i withObjectAtIndex:j];
//        }
//    }
//}


-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
//    NSMutableArray *arraytam = (NSMutableArray *)[self sortShopByDistance:shopsArray];
//    shopsArray = [[NSMutableArray alloc]initWithArray:arraytam];
////    for (int i = 0; i < [shopsArray count]; i ++) {
////        BeNCShopEntity *shop = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
////        int distance = [self caculateDistanceToShop:shop];
////        NSLog(@"ten cua hang la %@ va khoang cach %d",shop.shop_name,distance);
////    }
//    for (int i = 0; i < 5; i ++) {
//        BeNCDetailInCameraViewController *detailViewTest = (BeNCDetailInCameraViewController *)[arrayTest objectAtIndex:i];
//        [detailViewTest updateContentForView:(BeNCShopEntity *)[shopsArray objectAtIndex:i]];
//    }
}

- (void)dealloc
{
    [captureSession stopRunning];
    [captureSession release];
    [deviceInput release];
    [super dealloc];
}

@end
