//
//  LocationService.h
//  ARShop
//
//  Created by Applehouse on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationService : NSObject<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    
    
}
@property(nonatomic,retain) CLLocationManager *locationManager;

+(id)locationService;
-(id)init;
-(void)startUpdate;
@end
