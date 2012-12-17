//
//  BeNCShopGroupView.h
//  ARShop
//
//  Created by Applehouse on 12/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
#import "BeNCShopGroupAnnotation.h"
@interface BeNCShopGroupView : UIView{
    UIButton *_button;
    BeNCShopGroupAnnotation *annotation;
}
@property (nonatomic,retain) UIButton *button;    
@property (nonatomic,retain) BeNCShopGroupAnnotation *annotation;


@end
