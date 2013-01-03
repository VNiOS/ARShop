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
#import "BeNCOneShopARViewController.h"

@interface BeNCListViewController ()

@end

@implementation BeNCListViewController
@synthesize listShopView,userLocation,distanceToShop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{

    [self setTitle:@"List Shop"];
    [self getShopData];
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    self.listShopView.frame = CGRectMake(0, 0, 480, 320);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    [super viewDidLoad];

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

#pragma mark getdata


-(void)getShopData{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    shopsArray = [[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
    [self.listShopView reloadData];
    
}
-(int)calculeDistance:(BeNCShopEntity *)shop{

    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:shop.shop_latitude longitude:shop.shop_longitute];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notifi{
    CLLocation *newLocation = (CLLocation *)[notifi object];
    self.userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [self sortShopByDistance];
    [self.listShopView reloadData];
}

- (void)sortShopByDistance
{
    for (int i = 0; i < [shopsArray count]; i ++) {
        for (int j = i + 1; j < [shopsArray count]; j ++) {
            if ([self calculeDistance:[shopsArray objectAtIndex:i]] > [self calculeDistance:[shopsArray objectAtIndex:j]]) 
                [shopsArray exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
}

#pragma mark - Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [shopsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BeNCShopCellCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BeNCShopCellCell alloc] initWithStyle:UITableViewCellStyleSubtitle    reuseIdentifier:CellIdentifier] autorelease];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    BeNCShopEntity *shop  = [shopsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = shop.shop_name;
    cell.detailTextLabel.text = shop.shop_address;
    cell.imageView.image = [UIImage imageNamed:@"images.jpg"];
    
    NSString *distanceShop = [NSString stringWithFormat:@"%d m",[self calculeDistance:shop]];
    [cell.distanceToShop setTitle:distanceShop forState:UIControlStateNormal];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString *footer = [NSString stringWithFormat:@"%d shops in list",[shopsArray count]];
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:indexPath.row];
    BeNCDetailViewController *detailViewController = [[BeNCDetailViewController alloc] initWithShop:shopEntity];
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}

- (void)bnShoptCellDidClickedAtCell:(BeNCShopCellCell *)shopCell
{
    NSIndexPath *indexPathCell = [self.listShopView indexPathForCell:shopCell];
    BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:indexPathCell.row];
    BeNCOneShopARViewController *oneShopAR = [[BeNCOneShopARViewController alloc]initWithShop:shopEntity];
    [self.navigationController pushViewController:oneShopAR animated:YES];

}

@end
