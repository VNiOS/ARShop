//
//  BeNCListViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCListViewController.h"
#import "LocationService.h"
#import "BeNCDetailViewController.h"
#import "BeNCUtility.h"
#import "BeNCProcessDatabase.h"
#import "BeNCShopEntity.h"
#import "BeNCShopCellCell.h"

@interface BeNCListViewController ()

@end

@implementation BeNCListViewController
@synthesize listShopView,userLocation;

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
    userLocation = [[CLLocation alloc]init];
    [self setTitle:@"List Shop"];
    
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [super viewDidLoad];
    self.listShopView.frame = CGRectMake(0, 0, 480, 320);
    
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getShopData:) name:@"GetDatabase" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    [self getShopData];
}
#pragma mark getdata
-(void)getShopData{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    shopsArray = [[NSArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
//    NSLog(@"so phan tu cua mang = %i",[shopsArray count]);
    [self.listShopView reloadData];
    
}
-(int)calculeDistance:(BeNCShopEntity *)shop{


    //NSLog(@"shop %@ co toa do la %f %f",shop.shop_name ,shop.shop_latitude ,shop.shop_longitute);

//    NSLog(@"shop %@ co toa do la %f %f",shop.shop_name ,shop.shop_latitude ,shop.shop_longitute);

    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:shop.shop_latitude longitude:shop.shop_longitute];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
}
-(void)didUpdateHeading:(NSNotification *)notifi{
    //CLHeading *newHeading = (CLHeading *)[notifi object];
    
    //NSLog(@"heading la %f ", newHeading.magneticHeading*0.0174532925);
}
-(void)didUpdateLocation:(NSNotification *)notifi{
    CLLocation *newLocation = (CLLocation *)[notifi object];
    

    NSLog(@"ListView get new location : %f %f",newLocation.coordinate.latitude ,newLocation.coordinate.longitude);

//    NSLog(@"ListView get new location : %f %f",newLocation.coordinate.latitude ,newLocation.coordinate.longitude);
 

    self.userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [self.listShopView reloadData];
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [shopsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BeNCShopCellCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BeNCShopCellCell alloc] initWithStyle:UITableViewCellStyleSubtitle    reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    BeNCShopEntity *shop  = [shopsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = shop.shop_name;
    cell.detailTextLabel.text = shop.shop_address;
    cell.imageView.image = [UIImage imageNamed:@"images.jpg"];
    NSString *dis = [NSString stringWithFormat:@"%d m",[self calculeDistance:shop]];
<<<<<<< HEAD
=======
    //NSLog(@"shop %@ co distance la %@ ",shop.shop_name ,dis);
>>>>>>> 39997ae0ca7582d398b4c30069bfe4a9b18ff8db
    [cell.distanceBt setTitle:dis forState:UIControlStateNormal];
    return cell;
}



#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString *footer = [NSString stringWithFormat:@"%d shops in list",[shopsArray count]];
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      BeNCDetailViewController *detailViewController = [[BeNCDetailViewController alloc] initWithNibName:@"BeNCDetailViewController" bundle:nil];
    
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}


@end
