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
    NSArray *shopsArray;
    
}
@property (nonatomic,retain) MKMapView *mapView;
-(void)getShopData;
-(void)didUpdateLocation:(NSNotification *)notifi;
-(void)addShopAnnotation;
-(IBAction)showDetail:(id)sender;
-(void)checkOverride;
-(float)distanceOf:(CGPoint)point1 andpoint :(CGPoint)point2;
@end
