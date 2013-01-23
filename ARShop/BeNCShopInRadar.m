//
//  BeNCShopInRadar.m
//  ARShop
//
//  Created by Administrator on 1/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCShopInRadar.h"
#import "BeNCShopEntity.h"
#import "LocationService.h"
#import <math.h>
#define rotationRate 0.0174532925


@implementation BeNCShopInRadar
@synthesize userLocation,shop;
- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        frame.size.width = 5;
        frame.size.height = 5;
        shop = shopEntity;
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        distanceToShop = [self caculateDistanceToShop:shopEntity];
//        NSLog(@"khoang cach da duoc xet ti le la %f",distanceToShop);
        angleRotation = [self caculateRotationAngle:shopEntity];
        UIImage *arrowImage = [UIImage imageNamed:@"ShopInRadar.png"];
        self.image = arrowImage;
    }
    return self;
}
 
-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
    double newAngleToNorth =   newHeading.magneticHeading * rotationRate ;
    float angleToHeading = [self caculateRotationAngleToHeading:angleRotation withAngleTonorth:newAngleToNorth];
    [self setFrameForView:angleToHeading];
}
-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    distanceToShop = [self caculateDistanceToShop:shop];
    angleRotation = [self caculateRotationAngle:shop];
}

-(void)setFrameForView:(float )angleToHeading
{
    float a = tanf(angleToHeading);
    float b = 50 - 50 * a;
    float indexA = (1 + a * a);
    float indexB = (2 * a * b - 100 - 100 * a);
    float indexC = (5000 - 100 * b + b * b - distanceToShop * distanceToShop );
    float originX = [self giaiPhuongTrinhB2:indexA withIndexB:indexB withIndexC:indexC withAngle:angleToHeading];
    float originY = a * originX + b;
    frame.origin.x = originX;
    frame.origin.y = originY;
    self.frame = frame;
}

- (float)giaiPhuongTrinhB2:(float )a withIndexB:(float)b withIndexC:(float )c withAngle:(float)angle
{
    float x;
    float delta = (b * b) - ( 4 * a * c );
    float x1;
    float x2;
    x1 = (- b +  (sqrtf(delta))) / (2 * a);
    x2 = (- b -  (sqrtf(delta))) / (2 * a);
    if ((M_PI_2 <= angle && angle <= M_PI ) || (-M_PI <= angle && angle <= -M_PI_2)) {
         x = MAX(x1, x2);
    }
    else {
        x = MIN(x1, x2);
    }
    return x;

}
- (float)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute]autorelease];
    float distance = (float)[shoplocation distanceFromLocation: self.userLocation];
    float tiLe = 38.0/5000.0;
    return distance * tiLe;
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


@end
