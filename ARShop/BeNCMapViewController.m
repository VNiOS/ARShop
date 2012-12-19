//
//  BeNCMapViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCMapViewController.h"
#import "BeNCDetailViewController.h"
#import "LocationService.h"
#import "BeNCProcessDatabase.h"
#import "BeNCShopEntity.h"
#import "BeNCShopAnnotation.h"
#import "BeNCShopGroupAnnotation.h"
#import "CalloutMapAnnotationView.h"
@interface BeNCMapViewController ()

@end

@implementation BeNCMapViewController
@synthesize mapView;
@synthesize selectedAnnotationView = _selectedAnnotationView;
bool firstUpdate = 1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
<<<<<<< HEAD
    self.title = @"Map";
=======

    self.title = @"Map";

    self.view.transform = CGAffineTransformIdentity;

>>>>>>> b7bdc2a6cee1c6733870a669a50850ebf59fc417
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [super viewDidLoad];
    
    
    mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
    [mapView setDelegate:self];
    [mapView setShowsUserLocation:YES];
<<<<<<< HEAD
    
    [self.view addSubview:mapView];
    
  

    [self.view addSubview:mapView];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];    
=======
    [self.view addSubview:mapView];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];

>>>>>>> b7bdc2a6cee1c6733870a669a50850ebf59fc417
    [self getShopData];

}
-(void)getShopData{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    shopsArray = [[NSArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
    [self addShopAnnotation];
}

-(void)addShopAnnotation{
    for (int i=0; i<shopsArray.count; i++) {
        
        BeNCShopEntity *shop = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
        //NSLog(@"khoi tao annotation %d la %@",i,shop.shop_name);
      
        CLLocationCoordinate2D placeCoord;
        
        placeCoord.latitude=shop.shop_latitude;
        placeCoord.longitude=shop.shop_longitute;
             
        BeNCShopAnnotation *shopAnnotation=[[BeNCShopAnnotation alloc]initWithName:shop.shop_name address:shop.shop_address coordinate:placeCoord];
        shopAnnotation.index=i;
        shopAnnotation.shop = shop;
        [shopAnnotation.overideAnnotation addObject:shop];         
       [mapView addAnnotation:shopAnnotation];
    }

}
-(void)didUpdateLocation:(NSNotification *)notifi{
    
    CLLocation *newLocation = (CLLocation *)[notifi object];
    
    if (firstUpdate) {
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        MKCoordinateRegion adjustedRegion = [mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 1200, 1200)];
        [mapView setRegion:adjustedRegion animated:YES];
        firstUpdate=0;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
#pragma mark mapViewDelegate
-(void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views{
    
//    NSLog(@"Annotation add :%d",views.count);
    
}
- (void)mapView:(MKMapView *)mv regionDidChangeAnimated:(BOOL)animated {
    [self checkOverride];
}    

-  (void)mapView:(MKMapView *)mapview didSelectAnnotationView:(MKAnnotationView *)view
{
    if (view.annotation isKindOfClass:[BeNCShopAnnotation class]) {
        [view];
    }
      
}
-(void )mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {
    // Define your reuse identifier.
    static NSString *identifier = @"CalloutAnnotation";   
    //NSLog(@"view for annotation");
    if ([annotation isKindOfClass:[BeNCShopAnnotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
        } else {
            annotationView.annotation = annotation;
        }
        UIButton *button=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        [button addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView=button;
        
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"images.jpg"]];
        [icon setFrame:CGRectMake(0, 0, 30, 30)];
        annotationView.leftCalloutAccessoryView=icon;
        
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        
        return annotationView;
    
            
    
    
    
    }
    return nil;    
}
-(IBAction)showDetail:(id)sender{
    BeNCDetailViewController *detailViewController = [[BeNCDetailViewController alloc] initWithNibName:@"BeNCDetailViewController" bundle:nil];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}
-(void)checkOverride{
    NSLog(@"Location in view ___________________");
    for( id<MKAnnotation> annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[BeNCShopAnnotation class]]) {
            BeNCShopAnnotation *shopAnnotation = (BeNCShopAnnotation *)annotation;
            shopAnnotation.isChecked = 0;
            MKAnnotationView *annotationView = [mapView viewForAnnotation:shopAnnotation];
            [annotationView setHidden:NO];
            CGPoint locationInView = [mapView convertCoordinate:shopAnnotation.coordinate toPointToView:self.view];
            shopAnnotation.locationInView = locationInView;
        }
    }

    for( id<MKAnnotation> annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[BeNCShopAnnotation class]]) {
            BeNCShopAnnotation *shopAnnotation = (BeNCShopAnnotation *)annotation;
            
            [shopAnnotation.overideAnnotation removeAllObjects ];
            [shopAnnotation.overideAnnotation addObject:shopAnnotation.shop];    
                for( id<MKAnnotation> annotationCheck in mapView.annotations) {
                    if ([annotationCheck isKindOfClass:[BeNCShopAnnotation class]]) {
                        
                        BeNCShopAnnotation *shopcheck = (BeNCShopAnnotation *)annotationCheck;
<<<<<<< HEAD
                            if (shopcheck.index!=shopAnnotation.index &&shopcheck.isChecked==0 && [self distanceOf:shopAnnotation.locationInView andpoint:shopcheck.locationInView]<10) {
                                [shopAnnotation.overideAnnotation addObject:shopcheck];
//                                MKAnnotationView *View  =  [mapView viewForAnnotation:annotationCheck];
//                                [View setHidden:YES];
=======
                            if (shopcheck.index!=shopAnnotation.index && shopcheck.isChecked==0 && [self distanceOf:shopAnnotation.locationInView andpoint:shopcheck.locationInView]<10) {
                                [shopAnnotation.overideAnnotation addObject:shopcheck.shop];
                                
                                MKAnnotationView *shopCheckView  =  (MKAnnotationView *)[mapView viewForAnnotation:annotationCheck];
                                [shopCheckView setHidden:YES];
                                
                                
                                
                                
                                NSLog(@" * Shop %@ va shop %@ trung nhau",shopAnnotation.name,shopcheck.name);
>>>>>>> b7bdc2a6cee1c6733870a669a50850ebf59fc417
                                shopcheck.isChecked = 1;
                            }
  
                    }
                }
            MKPinAnnotationView *shopView = (MKPinAnnotationView *)[mapView viewForAnnotation:shopAnnotation];
            
            if (shopAnnotation.overideAnnotation.count>1) {
                shopView.pinColor = MKPinAnnotationColorGreen ;
            }
            else{
                shopView.pinColor = MKPinAnnotationColorRed ;
            }
            shopAnnotation.isChecked = 1;   
           
            
        }
    }
}
-(float)distanceOf:(CGPoint)point1 andpoint:(CGPoint)point2{
    CGFloat xDist = (point1.x - point2.x); 
    CGFloat yDist = (point1.y - point2.y); 
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}
@end
