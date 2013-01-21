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

@end
