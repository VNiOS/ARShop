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
@interface BeNCListViewController ()

@end

@implementation BeNCListViewController
@synthesize listShopView;

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
    [self setTitle:@"List Shop"];
    self.view.transform = CGAffineTransformIdentity;
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [super viewDidLoad];
    self.listShopView.frame = CGRectMake(0, 0, 480, 320);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getShopData:) name:@"GetDatabase" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    
}
-(void)getShopData:(NSNotification *)notification{
    NSLog(@"get shop data in LISTVIEW");
    shopsArray = [[NSMutableArray alloc]initWithArray:(NSArray *)[notification object]];
    [self.listShopView reloadData];
    
}
-(void)didUpdateHeading:(NSNotification *)notifi{
    CLHeading *newHeading = (CLHeading *)[notifi object];
    
    NSLog(@"Goc quay so voi North la %f ", newHeading.magneticHeading*0.0174532925);
}
-(void)didUpdateLocation:(NSNotification *)notifi{
    CLLocation *newLocation = (CLLocation *)[notifi object];
    
    NSLog(@"ListView get new location : %f %f",newLocation.coordinate.latitude ,newLocation.coordinate.longitude);
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle    reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Line %d",indexPath.row];
    NSDictionary *shop  = [shopsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [shop objectForKey:BeNCShopProperiesShopName];
    cell.detailTextLabel.text = [shop objectForKey:BeNCShopProperiesShopAddress];
    return cell;
}



#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      BeNCDetailViewController *detailViewController = [[BeNCDetailViewController alloc] initWithNibName:@"BeNCDetailViewController" bundle:nil];
    
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}


@end
