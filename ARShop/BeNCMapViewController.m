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
#import "BeNCListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BeNCAnnotationView.h"
#define MainList 0
#define MapList 1


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
    
    self.title = @"Map";
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [super viewDidLoad];
    
    
    mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
    [mapView setDelegate:self];
    [mapView setShowsUserLocation:YES];
    
    [self.view addSubview:mapView];
    
    UIButton *showUser = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showUser.frame = CGRectMake(20, 230, 120, 30);
    [showUser setTitle:@"Where am i ?" forState:UIControlStateNormal];
    showUser.alpha = 0.9;
    [showUser addTarget:self action:@selector(toUserLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showUser];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    
    [self getShopData];
    
}
-(void)getShopData{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    shopsArray = [[NSArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
    [self addShopAnnotation];
}

-(void)addShopAnnotation{
    shopsAnnotations = [[NSMutableArray alloc]init];
    for (int i=0; i<shopsArray.count; i++) {
        
        BeNCShopEntity *shop = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
        //NSLog(@"khoi tao annotation %d la %@",i,shop.shop_name);
        
        CLLocationCoordinate2D placeCoord;
        
        placeCoord.latitude=shop.shop_latitude;
        placeCoord.longitude=shop.shop_longitute;
        
        BeNCShopAnnotation *shopAnnotation=[[BeNCShopAnnotation alloc]initWithName:shop.shop_name address:shop.shop_address coordinate:placeCoord];
        shopAnnotation.index=i;
        shopAnnotation.isGrouped = 0;
        shopAnnotation.shop = shop;
        [shopAnnotation.overideAnnotation addObject:shop];
        [shopsAnnotations addObject:shopAnnotation];
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
    
    
    if ([view.annotation isKindOfClass:[BeNCShopAnnotation class]]) {
        
        BeNCShopAnnotation *shopAnnotation = (BeNCShopAnnotation *)view.annotation;
        
        if (shopAnnotation.overideAnnotation.count > 1) {
            shopAnnotation.title = [NSString stringWithFormat:@"%d shop",shopAnnotation.overideAnnotation.count];
        }
        else{
            shopAnnotation.title = shopAnnotation.name;
        }
        if (selectedShops ) {
            [selectedShops release];
        }
        selectedShops = [[NSMutableArray alloc]initWithArray:shopAnnotation.overideAnnotation];
        BeNCShopEntity *shop = (BeNCShopEntity *)[shopAnnotation.overideAnnotation objectAtIndex:0];
        NSLog(@"- Select annotation %@",shop.shop_name);
        NSLog(@"  Number of shop : %d",selectedShops.count);
        
    }
    
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"Deselect annotation");
}
-(MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"annotation";   
    if ([annotation isKindOfClass:[BeNCShopAnnotation class]]) {
        
        BeNCAnnotationView *annotationView = (BeNCAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[BeNCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
        } else {
            annotationView.annotation = annotation;
        }
        BeNCShopAnnotation *shopAnnotation = (BeNCShopAnnotation *)annotation;
        UIImage *img = [UIImage imageNamed:@"MapFrame.png"];
        annotationView.image = img ;
        CGPoint locationInView = [mapView convertCoordinate:shopAnnotation.coordinate toPointToView:self.view];
        NSLog(@"<<< Location in View %@ : %f %f",shopAnnotation.shop.shop_name,locationInView.x,locationInView.y);
        [annotationView setFrame:CGRectMake(locationInView.x, locationInView.y - 25, 45, 50)];
        
        if (shopAnnotation.overideAnnotation.count>1) {
            annotationView.numberlb.text = [NSString stringWithFormat:@"%d",shopAnnotation.overideAnnotation.count];
            
            annotationView.numberlb.hidden =NO;
            annotationView.numberImageView.hidden = NO;
        }
        else{
            annotationView.numberlb.hidden = YES;
            annotationView.numberImageView.hidden = YES;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [button addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = button;

        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    else{
        
    }
    return nil;    
}
-(IBAction)showDetail:(id)sender{
    if (selectedShops.count==1) {
        BeNCDetailViewController *detailViewController = [[BeNCDetailViewController alloc] initWithShop:(BeNCShopEntity *)[selectedShops objectAtIndex:0]];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    else{
        BeNCListViewController *listShopViewController = [[BeNCListViewController alloc]initWithNibName:@"BeNCListViewController" bundle:nil];
        [listShopViewController setListType:1];
        [listShopViewController getShopDataFromMap:selectedShops];
        [self.navigationController pushViewController:listShopViewController animated:YES];
        [listShopViewController release];
        
        
    }
    
    
}
-(IBAction)toUserLocation:(id)sender{
    
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate,1000,1000);
    
    [self.mapView setRegion:region animated:YES];
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if (![annotation isKindOfClass:[BeNCShopAnnotation class]]) {
            [self.mapView selectAnnotation:annotation animated:YES];
            break; 
        }
    }
  }
-(void)checkOverride{
    for( id<MKAnnotation> annotation in shopsAnnotations) {
        if ([annotation isKindOfClass:[BeNCShopAnnotation class]]) {
            BeNCShopAnnotation *shopAnnotation = (BeNCShopAnnotation *)annotation;
            shopAnnotation.isChecked = 0;
            CGPoint locationInView = [mapView convertCoordinate:shopAnnotation.coordinate toPointToView:self.view];
            shopAnnotation.locationInView = locationInView;
            //NSLog(@"Shop %@ co toa do la %f %f",shopAnnotation.shop.shop_name, locationInView.x,locationInView.y);
        }
    }
    
    for( id<MKAnnotation> annotation in shopsAnnotations) {
        if ([annotation isKindOfClass:[BeNCShopAnnotation class]]) {
            BeNCShopAnnotation *shopAnnotation = (BeNCShopAnnotation *)annotation;
            if (shopAnnotation.isChecked==0) {
                if (shopAnnotation.isGrouped == 1) {
                    [self.mapView addAnnotation:shopAnnotation];
                    
                }
                shopAnnotation.isGrouped = 0;
                [shopAnnotation.overideAnnotation removeAllObjects ];
                [shopAnnotation.overideAnnotation addObject:shopAnnotation.shop];    
                for( id<MKAnnotation> annotationCheck in shopsAnnotations) {
                    if ([annotationCheck isKindOfClass:[BeNCShopAnnotation class]]) {
                        
                        BeNCShopAnnotation *shopcheck = (BeNCShopAnnotation *)annotationCheck;
                        
                        if (shopcheck.index!=shopAnnotation.index && shopcheck.isChecked==0) {
                            
                            
                            if ([self distanceOf:shopAnnotation.locationInView andpoint:shopcheck.locationInView]<20) {
                                [shopAnnotation.overideAnnotation addObject:shopcheck.shop];
                                if (shopcheck.isGrouped == 0) {
                                    [self.mapView removeAnnotation:shopcheck];
                                }
                                shopcheck.isGrouped = 1;
                                shopcheck.isChecked = 1;
                                
                            }
                            else{
                                
                            }
                            
                        }
                        
                    }
                }
                BeNCAnnotationView *shopView = (BeNCAnnotationView *)[mapView viewForAnnotation:shopAnnotation];
                
                if (shopAnnotation.overideAnnotation.count>1) {
                    shopView.numberlb.text = [NSString stringWithFormat:@"%d",shopAnnotation.overideAnnotation.count];
                    shopView.numberImageView.hidden = NO;
                    shopView.numberlb.hidden = NO;
                }
                else{
                    shopView.numberImageView.hidden = YES;
                    shopView.numberlb.hidden = YES;
                }
                shopAnnotation.isChecked = 1;
            }
            
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
