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
#import "BeNCListViewController.h"
#import "BeNCShopAnnotation.h"
#import "BeNCDetailViewController.h"
@interface BeNCMapViewController : UIViewController<MKMapViewDelegate,ListViewOnMapDelegate,DetailViewDelegate>{
    
    MKMapView *mapView;
    
    NSArray *shopsArray;
    NSMutableArray *shopsAnnotations;
    
    NSMutableArray *selectedShops;
    BeNCShopAnnotation *selectedAnnotation;
}
@property (nonatomic,retain) MKMapView *mapView;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;

-(void)getShopData;
-(void)didUpdateLocation:(NSNotification *)notifi;
-(void)addShopAnnotation;
-(void)showDetail;
-(void)checkOverride;
-(float)distanceOf:(CGPoint)point1 andpoint :(CGPoint)point2;
-(IBAction)toUserLocation:(id)sender;
-(void)animationScaleOn:(UINavigationController *)navigation;

@end
