//
//  BeNCShopAnnotation.m
//  ARShop
//
//  Created by Applehouse on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCShopAnnotation.h"

@implementation BeNCShopAnnotation
@synthesize name=_name,address=_address,coordinate=_coordinate,title,subtitle,index,isChecked,isGrouped,locationInView,overideAnnotation,shop=_shop;
-(id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate{
    
    if (self=[super init]) {
        _name=name;
        _address=address;
        self.title=name;
        self.subtitle=address;
        _coordinate=coordinate;
        self.index=0;
        self.isChecked=NO;
        self.locationInView =CGPointMake(0, 0);
        self.overideAnnotation = [[[NSMutableArray alloc]init]autorelease];
    }
    return self;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle    reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.backgroundColor =[UIColor clearColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Shop %d",indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Address %d",indexPath.row];
    
    
    NSLog(@"callout tableview");
    return cell;
}



#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
