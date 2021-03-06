//
//  BeNCShopAnnotation.h
//  ARShop
//
//  Created by Applehouse on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BeNCShopEntity.h"
@interface BeNCShopAnnotation : NSObject<MKAnnotation,UITableViewDelegate,UITableViewDataSource>{
    
    BeNCShopEntity *_shop;
    
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
    
    NSString *title;
    NSString *subtitle;
    
    int index;
    bool isChecked;
    bool isGrouped;
    
    CGPoint locationInView;
    NSMutableArray *overideAnnotation;
    
}
@property(nonatomic,retain)  BeNCShopEntity *shop;


@property(nonatomic,copy)  NSString *title;
@property(nonatomic,copy)  NSString *subtitle;
@property (copy) NSString *name;
@property (copy) NSString *address;

@property(nonatomic) int index;
@property(nonatomic) bool isChecked;
@property(nonatomic) bool isGrouped;
@property(nonatomic) CGPoint locationInView;

@property(nonatomic,retain) NSMutableArray *overideAnnotation;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
@end
