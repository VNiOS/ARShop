//
//  BeNCMapViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface BeNCMapViewController : UIViewController<MKMapViewDelegate>{
    
    MKMapView *mapView;
    
}
@property (nonatomic,retain) MKMapView *mapView;

-(void)didUpdateLocation:(NSNotification *)notifi;
@end
