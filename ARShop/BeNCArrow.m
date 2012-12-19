//
//  BeNCArrow.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCArrow.h"
#import "BeNCShopEntity.h"
#import "LocationService.h"
#import <math.h>


@implementation BeNCArrow

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        shop = shopEntity;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];

        UIImage *arrowImage = [UIImage imageNamed:@"arrow.png"];
        self.image = arrowImage;
        self.frame = CGRectMake(10,0,30, 45);
        
        // Initialization code
    }
    return self;
}


-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity{
    userLocation = [[CLLocation alloc]init]; 
    CLLocation *shopLocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    CLLocationDistance distance = [shopLocation distanceFromLocation:userLocation];
    CLLocation *point =  [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:userLocation.coordinate.longitude];
    CLLocationDistance distance1 = [userLocation distanceFromLocation:point];
    
    double rotationAngle=acos(distance1/distance);
    if (userLocation.coordinate.latitude<=shopEntity.shop_latitude) {
        if (userLocation.coordinate.longitude<=shopEntity.shop_longitute) {
            return rotationAngle;
        }
        else{
            return - rotationAngle;
        }
        
        
    }
    else{
        if (userLocation.coordinate.longitude<shopEntity.shop_longitute) {
            double offsetAngle = M_PI - rotationAngle;
            return offsetAngle ;
        }
        else{
            double offseAngle = M_PI - rotationAngle;
            return -offseAngle;
        } 
        
    }
    
}

-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
    self.transform = CGAffineTransformMakeRotation(- (newHeading.magneticHeading * 0.0174532925 + 90) + rotationAngleArrow);
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    rotationAngleArrow = [self caculateRotationAngle:shop];
}
- (void)dealloc
{
    [shop release];
    [userLocation release];
    [super dealloc];
}
@end
