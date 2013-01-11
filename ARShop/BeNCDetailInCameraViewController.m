//
//  BeNCDetailInCameraViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCDetailInCameraViewController.h"
#import "BeNCShopEntity.h"
#import "BeNCArrow.h"
#import "BeNCDetailShopInCamera.h"
#import "BeNCArrow.h"
#import <QuartzCore/QuartzCore.h>
#define widthFrame 30
#define heightFrame 45


@interface BeNCDetailInCameraViewController ()

@end

@implementation BeNCDetailInCameraViewController
@synthesize shop,delegate,index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        userLocation = [[CLLocation alloc]init];
        motionManager = [[CMMotionManager alloc]init];
        motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        if (motionManager.isDeviceMotionAvailable) {
            [motionManager startDeviceMotionUpdates];
        }
    }
    return self;
}
- (void)setContentForView:(BeNCShopEntity *)shopEntity
{
    detailShop = [[BeNCDetailShopInCamera alloc]initWithShop:shopEntity];
    [detailShop updateContentDetailShop:shopEntity];
    detailShop.delegate = self;
    self.view.frame = detailShop.frame;
    [self.view addSubview:detailShop];
    
    arrowImage = [[BeNCArrow alloc]initWithShop:shopEntity];
    [self.view addSubview:arrowImage];
    [self.view setBackgroundColor:[UIColor clearColor]];
//    timer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateMotion) userInfo:nil repeats:YES]retain];   
}

- (void)setContentForView1:(BeNCShopEntity *)shopEntity
{
    detailShop = [[BeNCDetailShopInCamera alloc]initWithShop:shopEntity];
    [detailShop setContentDetailShop:shopEntity];
    detailShop.delegate = self;
    CGRect frame = detailShop.frame;
    frame.size.height = frame.size.width + 30;
    self.view.frame = frame;
    
    CGRect frame1 = detailShop.frame;
    frame1.origin.x = 0;
    frame1.origin.y = 30;
    detailShop.frame = frame1;
    [self.view addSubview:detailShop];
    
    arrowImage = [[BeNCArrow alloc]initWithShop:shopEntity];
    arrowImage.frame = CGRectMake(frame.size.width/2 - 15, 0 , 20, 30);
    [self.view addSubview:arrowImage];
    [self.view setBackgroundColor:[UIColor clearColor]];
}


- (void)updateMotion
{
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    float roll = currentAttitude.roll;
    float pitch = currentAttitude.pitch;
    float yaw = currentAttitude.yaw;
    float scaleWidth = ( widthFrame * cosf(pitch) )/widthFrame;
    float scaleHeight = ( heightFrame * cosf(roll) )/heightFrame;
    if (scaleWidth < 0.1) {
        scaleWidth = 0.1;
    }
    if (scaleHeight < 0.1) {
        scaleHeight = 0.1;
    }
    CGAffineTransform transfromScale = CGAffineTransformMakeRotation(yaw);
    arrowImage.transform = CGAffineTransformScale(transfromScale, 1, scaleHeight);
    [arrowImage setCenter:CGPointMake(22, 22)];
}
- (void)viewDidLoad
{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)setIndexForView:(int )aIndex
{
    index = aIndex;
}
- (void)didTouchesToView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeclectView:)]) {
        [self.delegate didSeclectView:self.index];
    }
}
- (void)dealloc
{
    [timer release];
    [super dealloc];
}

@end
