//
//  BeNCShopAnnotation.m
//  ARShop
//
//  Created by Applehouse on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCShopAnnotation.h"

@implementation BeNCShopAnnotation
@synthesize name=_name,address=_address,coordinate=_coordinate,title,subtitle,index,isGroup;
-(id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate{
    
    if (self=[super init]) {
        _name=name;
        _address=address;
        self.title=name;
        self.subtitle=address;
        _coordinate=coordinate;
        self.index=0;
        self.isGroup=NO;
        
        
        
    }
    return self;
    
}
@end
