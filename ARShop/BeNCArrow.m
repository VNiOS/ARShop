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
#define rotationRate 0.0174532925


@implementation BeNCArrow
@synthesize shop;

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        userLocation = [[CLLocation alloc]init];
        shop = shopEntity;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        UIImage *arrowImage = [UIImage imageNamed:@"arrow.png"];
        self.image = arrowImage;
        self.frame = CGRectMake(10,0,30, 45);
    }
    return self;
}


-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity{
<<<<<<< HEAD
=======
    userLocation = [[CLLocation alloc]init]; 
>>>>>>> b7bdc2a6cee1c6733870a669a50850ebf59fc417
    CLLocation *shopLocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    CLLocationDistance distance = [shopLocation distanceFromLocation:userLocation];
    CLLocation *point =  [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:userLocation.coordinate.longitude];
    CLLocationDistance distance1 = [userLocation distanceFromLocation:point];
    double rotationAngle;
    
<<<<<<< HEAD
    double angle=acos(distance1/distance);
    if (userLocation.coordinate.latitude<=shopEntity.shop_latitude) {
        if (userLocation.coordinate.longitude<=shopEntity.shop_longitute) {
            rotationAngle = angle;
        }
        else{
            rotationAngle = - angle;
=======
    double rotationAngle=acos(distance1/distance);
    if (userLocation.coordinate.latitude<=shopEntity.shop_latitude) {
        if (userLocation.coordinate.longitude<=shopEntity.shop_longitute) {
            return rotationAngle;
        }
        else{
            return - rotationAngle;
>>>>>>> b7bdc2a6cee1c6733870a669a50850ebf59fc417
        }
        
        
    }
    else{
        if (userLocation.coordinate.longitude<shopEntity.shop_longitute) {
<<<<<<< HEAD
            rotationAngle = M_PI - angle;
        }
        else{
            rotationAngle = M_PI - angle;
            
=======
            double offsetAngle = M_PI - rotationAngle;
            return offsetAngle ;
        }
        else{
            double offseAngle = M_PI - rotationAngle;
            return -offseAngle;
>>>>>>> b7bdc2a6cee1c6733870a669a50850ebf59fc417
        } 
    }
    return rotationAngle;
}

-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
<<<<<<< HEAD
    self.transform = CGAffineTransformMakeRotation(- (newHeading.magneticHeading * rotationRate + M_PI/2));
=======
    self.transform = CGAffineTransformMakeRotation(- (newHeading.magneticHeading * 0.0174532925 + 90) + rotationAngleArrow);
>>>>>>> b7bdc2a6cee1c6733870a669a50850ebf59fc417
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    rotationAngleArrow = [self caculateRotationAngle:shop];
<<<<<<< HEAD
//    self.transform = CGAffineTransformMakeRotation(rotationAngleArrow);
//    NSLog(@"goc quay to shop %@ la %f",shop.shop_name,rotationAngleArrow);

=======
>>>>>>> b7bdc2a6cee1c6733870a669a50850ebf59fc417
}
- (void)dealloc
{
    [shop release];
    [userLocation release];
    [super dealloc];
}
@end
