//
//  BeNCDetailInAR3D.h
//  ARShop
//
//  Created by Administrator on 1/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCDetailInCamera.h"
@interface BeNCDetailInAR3D : BeNCDetailInCamera{
    double angleRotation;
    CGRect frame;
    float distanceShop;
}
- (id)initWithShop:(BeNCShopEntity *)shopEntity;
-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity;
-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth;
- (float)giaiPhuongTrinhB2:(float )a withIndexB:(float)b withIndexC:(float )c withAngle:(float)angle;
-(void)setFrameForView:(float )angleToHeading;
- (float)caculateDistanceShop:(BeNCShopEntity *)shopEntity;
- (void)scaleViewWithDistace;

@end
