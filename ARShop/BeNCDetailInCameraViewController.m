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
#import "LocationService.h"
#define widthFrame 30
#define heightFrame 45
#define textSize 18
#define max 100000


@interface BeNCDetailInCameraViewController ()

@end

@implementation BeNCDetailInCameraViewController
@synthesize shop,delegate,index,userLocation;

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        shop = shopEntity;
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shopEntity]];
        [self setContentForView:shopEntity];
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchesToView)];
        recognizer.delegate = self;
        [self.view addGestureRecognizer:recognizer];
    }
    return self;
}


- (void)setContentForView:(BeNCShopEntity *)shopEntity
{
    float sizeWith = [self calculateSizeFrame:shopEntity];
//    CGRect frame ;
//    frame.size.height = 110;
//    frame.size.width = sizeWith;
//    self.view.frame = frame;  
    self.view.frame = CGRectMake(0, 0, sizeWith, 110);
    
    detailShop = [[BeNCDetailShopInCamera alloc]initWithShop:shopEntity];
    detailShop.delegate = self;
    detailShop.frame = CGRectMake(0, 30, sizeWith, 30);
    [self.view addSubview:detailShop];
    
    arrowImage = [[BeNCArrow alloc]initWithShop:shopEntity];
    float tdoX = sizeWith/2 - 15;
    arrowImage.frame = CGRectMake(tdoX , 0 , 20, 30);
    [self.view addSubview:arrowImage];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
}


- (void)viewDidLoad
{
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)setIndexForView:(int )aIndex
{
    index = aIndex;
}
- (void)didTouchesToView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeclectView:)]) {
        NSLog(@"test delegate co den k");
        [self.delegate didSeclectView:self.index];
    }
}
-(float)calculateSizeFrame:(BeNCShopEntity *)shopEntity
{
    CGSize labelShopNameSize = [shopEntity.shop_name sizeWithFont:[UIFont boldSystemFontOfSize:textSize - 2] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    CGSize labelShopAddressSize = [shopEntity.shop_address sizeWithFont:[UIFont systemFontOfSize:textSize - 6] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    float originLabelDistance = MAX(labelShopNameSize.width, labelShopAddressSize.width);      
    CGSize toShopSize = [distanceToShop sizeWithFont:[UIFont systemFontOfSize:textSize - 4] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    float sizeWidth = originLabelDistance + toShopSize.width + 7;
    return sizeWidth;

}

- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute]autorelease];
    int distance = (int)[shoplocation distanceFromLocation: userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shop]];
}


- (void)dealloc
{
    [timer release];
    [super dealloc];
}


@end
