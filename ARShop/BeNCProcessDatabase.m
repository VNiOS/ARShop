//
//  BeNCProcessDatabase.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCProcessDatabase.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "BeNCAppDelegate.h"
#import "BeNCUtility.h"
#import "BeNCShopEntity.h"

@implementation BeNCProcessDatabase
@synthesize arrayShop;

static BeNCProcessDatabase *shareDatabase = nil;

+(BeNCProcessDatabase*)sharedMyDatabase
{
	@synchronized([BeNCProcessDatabase class])
	{
		if (!shareDatabase)
			[[self alloc] init];
        
		return shareDatabase;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([BeNCProcessDatabase class])
	{
		NSAssert(shareDatabase == nil, @"Attempted to allocate a second instance of a singleton.");
		shareDatabase = [super alloc];
		return shareDatabase;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
    
	return self;
}

-(void)getDatebase {
    BeNCAppDelegate  *appDelegate = (BeNCAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *databasePath = appDelegate.databasePath;
    NSLog(@"path = %@",appDelegate.databasePath);
    database = [[FMDatabase databaseWithPath:databasePath]retain];
    [self getDatabaseShop];
}

- (NSArray *)getDatabaseShop
{
    [database open];
    NSLog(@"start get data________");
    NSMutableArray *shops = [[NSMutableArray alloc]init];
    FMResultSet *results  = [database executeQuery:[NSString stringWithFormat:@"select *from shops order by shop_name"]];
    while ([results next]) {
        
        NSMutableDictionary *shop = [[NSMutableDictionary alloc] init];
        NSNumber *shop_id = [[NSNumber alloc] initWithInt:[results intForColumn:BeNCShopProperiesShopId]];
        NSNumber *shop_type = [[NSNumber alloc] initWithInt:[results intForColumn:BeNCShopProperiesShopTye]];
        NSNumber *shop_phone = [[NSNumber alloc] initWithInt:[results intForColumn:BeNCShopProperiesShopPhone]];
        
        
        NSNumber *shop_latitude = [[NSNumber alloc] initWithFloat:[results doubleForColumn:BeNCShopProperiesShopLatitude]];
        //NSLog(@" latitude : %lf",[shop_latitude doubleValue]);
        NSNumber *shop_longitude = [[NSNumber alloc] initWithFloat:[results doubleForColumn:BeNCShopProperiesShopLongitude]];
        //NSLog(@" longitude : %lf",[shop_longitude doubleValue]);
        
        NSString *shop_name = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopName]];
        NSString *shop_address = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopAddress]];
        NSString *shop_address_detail = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopAddressDetail]];
        NSString *shop_description = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopDescription]];
        NSString *shop_coupon_link = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopCouponLink]];

        NSString *shop_menu_link = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopMenuLink]];
        NSString *shop_open_time = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopOpenTime]];
        NSString *shop_close_time = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopCloseTime]];
        

        [shop setObject:shop_id forKey:BeNCShopProperiesShopId];
        [shop setObject:shop_name forKey:BeNCShopProperiesShopName];
        [shop setObject:shop_type forKey:BeNCShopProperiesShopTye];
        [shop setObject:shop_address forKey:BeNCShopProperiesShopAddress];
        [shop setObject:shop_address_detail forKey:BeNCShopProperiesShopAddressDetail];
        [shop setObject:shop_description forKey:BeNCShopProperiesShopDescription];
        [shop setObject:shop_coupon_link forKey:BeNCShopProperiesShopCouponLink];
        [shop setObject:shop_menu_link forKey:BeNCShopProperiesShopMenuLink];
        [shop setObject:shop_phone forKey:BeNCShopProperiesShopPhone];
        [shop setObject:shop_open_time forKey:BeNCShopProperiesShopOpenTime];
        [shop setObject:shop_close_time forKey:BeNCShopProperiesShopCloseTime];
        [shop setObject:shop_latitude forKey:BeNCShopProperiesShopLatitude];
        [shop setObject:shop_longitude forKey:BeNCShopProperiesShopLongitude];
        
        BeNCShopEntity *newShop = [[BeNCShopEntity alloc]initWithDictionary:shop];
        [shops addObject:newShop];
        [newShop release];
        }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GetDatabase" object:shops];
    NSLog(@"post database !!!");
    [database close];
    return [NSArray arrayWithArray:shops];
    
    
}
- (void)dealloc
{
    [arrayShop release];
    [database release];
    [super dealloc];
}


@end
