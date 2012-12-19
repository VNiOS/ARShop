//
//  BeNCShopGroupAnnotation.h
//  ARShop
//
//  Created by Applehouse on 12/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface BeNCShopGroupAnnotation : NSObject<MKAnnotation>{
    NSString *title;
    NSArray *_shopList;
    CLLocationCoordinate2D _coordinate;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSArray *shopList;
-(id)initwithLocation :(CLLocationCoordinate2D) coordinate andShopArray:(NSArray *)shops ;
@end
