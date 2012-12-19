//
//  BeNCShopGroupAnnotation.m
//  ARShop
//
//  Created by Applehouse on 12/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCShopGroupAnnotation.h"

@implementation BeNCShopGroupAnnotation
@synthesize coordinate = _coordinate,shopList = _shopList;
-(id)initwithLocation :(CLLocationCoordinate2D) coordinate andShopArray:(NSArray *)shops {
    if (self=[super init]) {
        _coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        _shopList = [[NSArray alloc]initWithArray:shops];
    }
    return self;
}
@end
