//
//  LocationService.m
//  ARShop
//
//  Created by Applehouse on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService
@synthesize locationManager;

-(id)init{
    if (self = [super init]) {
        
        self.locationManager = [[CLLocationManager alloc]init];
        
        self.locationManager.delegate=self;
        self.locationManager.headingFilter=kCLHeadingFilterNone;
        
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"init" object:nil];

        NSLog(@"init");
    }
    return self;
}

+(id)sharedLocation{
    LocationService *service = nil;
    service = [[LocationService alloc]init];
    return service;
}


-(void)startUpdate{

    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    NSLog(@"Start Update");
}
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
     [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateHeading" object:newHeading];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
      [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateLocation" object:newLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Update location fail");
}


-(void)dealloc{
    
    [super dealloc];
}
@end
