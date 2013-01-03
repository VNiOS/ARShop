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

@interface BeNCOneShopARViewController ()

@end

@implementation BeNCOneShopARViewController

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
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
    BeNCDetailInCameraViewController *detailView = [[BeNCDetailInCameraViewController alloc]initWithNibName:@"BeNCDetailInCameraViewController" bundle:nil];
    [detailView setContentForView:shopEntity];
    CGRect frame = detailView.view.frame;
    frame.origin.x = 25;
    frame.origin.y = 50;
    detailView.view.frame = frame;
    [self.view addSubview:detailView.view];
}

@end
