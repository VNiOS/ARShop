//
//  BeNCRadarViewController.m
//  ARShop
//
//  Created by Administrator on 1/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCRadarViewController.h"
#import "BeNCShopEntity.h"
#import "LocationService.h"
#import "BeNCProcessDatabase.h"
#import "BeNCShopInRadar.h"
@interface BeNCRadarViewController ()

@end

@implementation BeNCRadarViewController
@synthesize shopArray,userLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        userLocation = [[LocationService sharedLocation]getOldLocation];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        // Custom initialization
        [self setcontentForView];
        [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
        self.shopArray = [[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
        for (int i = 0; i < [shopArray count]; i ++) {
            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopArray objectAtIndex:i];
            BeNCShopInRadar *shopInRadar = [[BeNCShopInRadar alloc]initWithShop:shopEntity];
            [self.view addSubview:shopInRadar];

        }
            }
    return self;
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor clearColor]];
//    [self setcontentForView];
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
-(void)setcontentForView
{
    UIImageView *imageViewRadar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIImage *imageRadar = [UIImage imageNamed:@"Radar.png"];
    imageViewRadar.image = imageRadar;
    [self.view addSubview:imageViewRadar];
}

-(void)getDatasebase
{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    self.shopArray = [[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
}
- (NSArray *)processDatabaseForView
{
    NSMutableArray *mutableArrayShop = [[NSMutableArray alloc]init];
    for (int i = 0; i < [shopArray count]; i ++) {
        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopArray objectAtIndex:i];
        int distanceToShop = [self caculateDistanceToShop:shopEntity];
        if (distanceToShop < 10000) {
            [mutableArrayShop addObject:shopEntity];
        }
    }
    return mutableArrayShop;
}

- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute]autorelease];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
}


//-(void)didUpdateHeading:(NSNotification *)notification{
//    CLHeading *newHeading = [notification object];
//}
//
//-(void)didUpdateLocation:(NSNotification *)notification {
//    CLLocation *newLocation = (CLLocation *)[notification object];
//    [userLocation release];
//    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
//}
//
//-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity{
//    CLLocation *shopLocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
//    CLLocationDistance distance = [shopLocation distanceFromLocation:userLocation];
//    CLLocation *point =  [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:userLocation.coordinate.longitude];
//    CLLocationDistance distance1 = [userLocation distanceFromLocation:point];
//    double rotationAngle;
//    
//    double angle=acos(distance1/distance);
//    if (userLocation.coordinate.latitude<=shopEntity.shop_latitude) {
//        if (userLocation.coordinate.longitude<=shopEntity.shop_longitute) {
//            rotationAngle = angle;
//        }
//        else{
//            rotationAngle = - angle;
//        }
//    }
//    else{
//        if (userLocation.coordinate.longitude<shopEntity.shop_longitute) {
//            rotationAngle = M_PI - angle;
//        }
//        else{
//            rotationAngle = -(M_PI - angle);
//        }
//    }
//    return rotationAngle;
//}
//
//
//-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth
//{
//    float angleToHeading;
//    if (angleToShop >= 0) {
//        angleToHeading = angleToShop - angleToNorth;
//        if (angleToHeading < - M_PI) {
//            angleToHeading = 2 * M_PI - (angleToNorth - angleToShop);
//        }
//    }
//    else if (angleToShop < 0){
//        angleToHeading =  angleToShop - angleToNorth;
//        
//        if ( angleToHeading < - M_PI) {
//            angleToHeading = 2 * M_PI + angleToHeading;
//        }
//    }
//    return angleToHeading;
//    
//}

@end
