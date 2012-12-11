//
//  BeNCListViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCListViewController.h"
#import "LocationService.h"
@interface BeNCListViewController ()

@end

@implementation BeNCListViewController

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
    [self.view setBackgroundColor:[UIColor yellowColor]];
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [super viewDidLoad];
    


    [[LocationService locationService]startUpdate];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)didUpdateHeading:(NSNotification *)notifi{
    CLHeading *newHeading = (CLHeading *)[notifi object];
    NSLog(@"Goc quay so voi North la %f ", newHeading.magneticHeading*0.0174532925);
}
-(void)didUpdateLocation:(NSNotification *)notifi{
    CLLocation *newLocation = (CLLocation *)[notifi object];
    
    NSLog(@"Toa do moi la : %f %f",newLocation.coordinate.latitude ,newLocation.coordinate.longitude);
    
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

@end
