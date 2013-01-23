//
//  BeNCDetailInAR3D.m
//  ARShop
//
//  Created by Administrator on 1/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCDetailInAR3D.h"
#import "LocationService.h"
#define rotationRate 0.0174532925


@implementation BeNCDetailInAR3D

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        shop = shopEntity;
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shopEntity]];
        distanceShop = [self caculateDistanceShop:shopEntity];
        angleRotation = [self caculateRotationAngle:shopEntity];
        [self setContentForView:shopEntity];
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchesToView)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setFrameForView:(float )angleToHeading
{
    float a = tanf(angleToHeading);
//    NSLog(@"gia tri cua a = %f",a);
    float b = 250 - 240 * a;
    float newCenterX;
    float newCenterY;
    if (0 <= angleToHeading && angleToHeading <= M_PI) {
        newCenterY = 250 - distanceShop;
    }
    else {
        newCenterY = 250 + distanceShop;
    }

    newCenterX = (newCenterY - b)/a ;
    if (newCenterY > 230) {
        newCenterY = 230;
    }
    self.center = CGPointMake(newCenterX, newCenterY);
    
//    NSLog(@"gia tri cua b = %f",b);
//    float indexA = (1 + a * a);
//    NSLog(@"gia tri cua indexA = %f",indexA);
//    float indexB = (2 * a * b - 480 - 500 * a);
//    NSLog(@"gia tri cua indexB = %f",indexB);

//    float indexC = (120100 - 500 * b + b * b - distanceShop * distanceShop );
//    NSLog(@"gia tri cua indexC = %f",indexC);

//    float newCenterX;
//    float newCenterY;
//
//    newCenterX = [self giaiPhuongTrinhB2:indexA withIndexB:indexB withIndexC:indexC withAngle:angleToHeading];
//    newCenterY = a * newCenterX + b;
//    if (0 < newCenterY && newCenterY < 270) {
//        newCenterY = 100;
//    }

//    frame.origin.x = originX;
//    frame.origin.y = originY;
//    self.frame = frame;
//    self.center = CGPointMake(newCenterX, newCenterY);
}

- (float)giaiPhuongTrinhB2:(float )a withIndexB:(float)b withIndexC:(float )c withAngle:(float)angle
{
    float x;
    float delta = (b * b) - ( 4 * a * c );
//    NSLog(@"gia tri cua delta = %f",delta);
    float x1;
    float x2;
    x1 = (- b +  (sqrtf(delta))) / (2 * a);
    x2 = (- b -  (sqrtf(delta))) / (2 * a);
//    NSLog(@"nghiem cua phuong trinh la %f va %f",x1,x2);

    if ((M_PI_2 <= angle && angle <= M_PI ) || (-M_PI <= angle && angle <= -M_PI_2)) {
        x = MAX(x1, x2);
    }
    else {
        x = MIN(x1, x2);
    }
//    NSLog(@"nghiem cua phuong trinh la %f",x);
    return x;
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
- (float)caculateDistanceShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute]autorelease];
    float distance = (float)[shoplocation distanceFromLocation: self.userLocation];
    float tiLe = 347.0/5000.0;
//    NSLog(@"khoang cach den shop la %f",distance * tiLe);
    return distance * tiLe;

}

-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
    double newAngleToNorth =   newHeading.magneticHeading * rotationRate ;
    float angleToHeading = [self caculateRotationAngleToHeading:angleRotation withAngleTonorth:newAngleToNorth];
//    NSLog(@"goc cua shop so voi device la %f",angleToHeading);
    [self setFrameForView:angleToHeading];
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shop]];
    distanceShop = [self caculateDistanceShop:shop];
    angleRotation = [self caculateRotationAngle:shop];
}
@end
