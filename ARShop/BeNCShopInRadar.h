//
//  BeNCShopInRadar.h
//  ARShop
//
//  Created by Administrator on 1/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCShopEntity.h"
@interface BeNCShopInRadar : UIImageView{
    CLLocation *userLocation;
    BeNCShopEntity *shop;
    float distanceToShop;
    double angleRotation;
    CGRect frame;

}
@property(nonatomic, retain)CLLocation *userLocation;
@property(nonatomic, retain)BeNCShopEntity *shop;
- (id)initWithShop:(BeNCShopEntity *)shopEntity;
- (float)caculateDistanceToShop:(BeNCShopEntity *)shopEntity;
-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity;
-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth;
- (float)giaiPhuongTrinhB2:(float )a withIndexB:(float)b withIndexC:(float )c withAngle:(float)angle;
@end
