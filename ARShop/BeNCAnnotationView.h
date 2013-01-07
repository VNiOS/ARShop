//
//  BeNCAnnotationView.h
//  ARShop
//
//  Created by Applehouse on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface BeNCAnnotationView : MKAnnotationView{
    UIImageView *numberImageView;
    UILabel *numberlb;
}
@property(nonatomic,retain)  UIImageView *numberImageView;
@property(nonatomic,retain)  UILabel *numberlb;
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
