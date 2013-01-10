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

#define MainList 0
#define MapList 1

@interface BeNCListViewController ()

@end

@implementation BeNCListViewController
@synthesize listShopView,userLocation,distanceToShop;
@synthesize listType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userLocation = [[LocationService sharedLocation]getOldLocation];
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
<<<<<<< HEAD
    refreshButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" style:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = refreshButtonItem;
    editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonSystemItemRefresh target:self action:@selector(editList:)];
    arrayButtonItem =  [[NSMutableArray arrayWithObjects:editButton,refreshButtonItem, nil]retain];

    self.navigationItem.rightBarButtonItems = arrayButtonItem;
=======
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" style:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
        editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonSystemItemRefresh target:self action:@selector(editList:)];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(closeListViewInMap:)];
>>>>>>> ffd31131eb66c4b7b74cd6a1fbd08baf43758d87
    
    [self setTitle:@"List Shop"];
    
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    self.listShopView.frame = CGRectMake(0, 0, 480, 320);
    listShopView.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    
    if (listType == MainList) {
        self.navigationItem.rightBarButtonItem = refreshButtonItem;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:refreshButtonItem,editButton, nil];
        [self getShopData];
        NSLog(@"main list");
    }
    else if(listType == MapList){
        self.navigationItem.rightBarButtonItem = done;
        NSLog(@"map list");
    }
    [super viewDidLoad];

}
-(IBAction)closeListViewInMap:(id)sender{
    NSLog(@"Close list view");
    [self.navigationController.view removeFromSuperview];
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
-(void)getShopDataFromMap:(NSArray *)shopArray{
    NSLog(@"get shop data from map");
    shopsArray = [[NSMutableArray alloc]initWithArray:shopArray];
    if (self.userLocation==nil) {
       self.userLocation = [[LocationService sharedLocation]getOldLocation]; 
    }
    [self.listShopView reloadData];
}

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

- (void)refreshData
{
    if (!editing) {
        shopsArray = [[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
        [self sortShopByDistance];
        [self.listShopView reloadData];
    }
    

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
        cell = [[BeNCShopCellCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BeNCShopEntity *shop  = [shopsArray objectAtIndex:indexPath.row];
    if (shop.shopCheck == 1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone ;
    }
    
    [cell updateContentForCell:shop withLocation:userLocation];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    NSString *footer = [NSString stringWithFormat:@"%d shops in list",[shopsArray count]];
//    return footer;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editing) {
        BeNCShopEntity *shop  = [shopsArray objectAtIndex:indexPath.row];
        shop.shopCheck =! shop.shopCheck;
        [self.listShopView reloadData];
        
    }
    else {
    BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:indexPath.row];
    BeNCDetailViewController *detailViewController = [[BeNCDetailViewController alloc] initWithShop:shopEntity];
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
   }
}


- (void)bnShoptCellDidClickedAtCell:(BeNCShopCellCell *)shopCell
{
    if (!editing) {
        NSIndexPath *indexPathCell = [self.listShopView indexPathForCell:shopCell];
        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:indexPathCell.row];
        BeNCOneShopARViewController *oneShopAR = [[BeNCOneShopARViewController alloc]initWithShop:shopEntity];
        [self.navigationController pushViewController:oneShopAR animated:YES];
    }


}


- (IBAction)editList:(id)sender
{
    editing =! editing;
    if (editing) {
        [arrayButtonItem removeObjectAtIndex:1];
        self.navigationItem.rightBarButtonItems = arrayButtonItem;
        for (int  i = 0; i < [shopsArray count]; i ++) {
            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
            shopEntity.shopCheck = 1;
        }  
        [self.listShopView reloadData];
    }
    else {
        [arrayButtonItem addObject:refreshButtonItem];
        self.navigationItem.rightBarButtonItems = arrayButtonItem;
        for (int  i = 0; i < [shopsArray count]; i ++) {
            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
            
            if (shopEntity.shopCheck == 0) {
                [shopsArray removeObject:shopEntity];
            }
        }
        [self.listShopView reloadData];
        for (int  i = 0; i < [shopsArray count]; i ++) {
            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
            shopEntity.shopCheck = 0;
        } 
        [self.listShopView reloadData];

        }


}
- (void)dealloc
{
    [shopsArray release];
    [arrayButtonItem release];
    [editButton release];
    [refreshButtonItem release];
    [userLocation release];
    [listShopView release];
    [super dealloc];
}
@end
