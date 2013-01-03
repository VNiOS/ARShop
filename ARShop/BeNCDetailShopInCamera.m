//
//  BeNCDetailShopInCamera.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCDetailShopInCamera.h"
#import "BeNCShopEntity.h"
#import "LocationService.h"
#import <QuartzCore/QuartzCore.h>
#define textSize 18
#define max 100000

@implementation BeNCDetailShopInCamera
@synthesize labelDistanceToShop,labelShopName,labelShopAddress,shop;
@synthesize userLocation;
@synthesize delegate;

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        shop = shopEntity;
        [[LocationService sharedLocation]startUpdate];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        labelShopName = [[UILabel alloc]init];
        [labelShopName setBackgroundColor:[UIColor clearColor]];
        labelShopAddress = [[UILabel alloc]init];
        [labelShopAddress setBackgroundColor:[UIColor clearColor]];
        labelDistanceToShop = [[UILabel alloc]init];
        [labelDistanceToShop setBackgroundColor:[UIColor clearColor]];

        [self addSubview:labelShopName];
        [self addSubview:labelShopAddress];
        [self addSubview:labelDistanceToShop];
        [self.layer setCornerRadius:10];
        self.alpha = 0.5; 
        [self updateContentDetailShop:shopEntity];

        // Initialization code
    }
    return self;
}

- (void)updateContentDetailShop:(BeNCShopEntity *)shopEntity
{
    labelShopName.text = shopEntity.shop_name;
    [labelShopName setFont:[UIFont boldSystemFontOfSize:textSize]];
    [labelShopName setTextAlignment:UITextAlignmentCenter];
    labelShopAddress.text = shopEntity.shop_address;
    [labelShopAddress setFont:[UIFont systemFontOfSize:textSize-4]];
    [labelShopAddress setTextAlignment:UITextAlignmentCenter];
    CGSize labelShopNameSize = [shopEntity.shop_name sizeWithFont:[UIFont boldSystemFontOfSize:textSize] constrainedToSize:CGSizeMake(max, 40) lineBreakMode:UILineBreakModeCharacterWrap];
    CGSize labelShopAddressSize = [shopEntity.shop_address sizeWithFont:[UIFont systemFontOfSize:textSize - 4] constrainedToSize:CGSizeMake(max, 30) lineBreakMode:UILineBreakModeCharacterWrap];
    float originLabelDistance = [self caculateMax:labelShopNameSize.width withNumberB:labelShopAddressSize.width];
    
    labelShopName.frame = CGRectMake(50, 0,originLabelDistance,25 );
    labelShopAddress.frame = CGRectMake(50, 20,originLabelDistance,25);
    labelDistanceToShop.frame = CGRectMake(originLabelDistance + 60, 0, 65, 45);
    self.frame = CGRectMake(0, 0,originLabelDistance + 125 ,50 );
    [self setBackgroundColor:[UIColor whiteColor]];
    
}
- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    labelDistanceToShop.text = [NSString stringWithFormat:@"%d m",[self caculateDistanceToShop:shop]];
}

- (float)caculateMax:(float )numberA withNumberB:(float )numberB
{
    int maxNumber;
    if (numberA >= numberB) {
        maxNumber = numberA;
    }
    else {
        maxNumber = numberB;
    }
    return maxNumber;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchesToView)]) {
        [self.delegate didTouchesToView];
    }
}
- (void)dealloc
{
    [shop release];
    [labelShopName release];
    [labelShopAddress release];
    [labelDistanceToShop release];
    [userLocation release];
    [super dealloc];
}
@end
