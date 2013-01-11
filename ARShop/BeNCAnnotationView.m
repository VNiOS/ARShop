//
//  BeNCAnnotationView.m
//  ARShop
//
//  Created by Applehouse on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCAnnotationView.h"
#import "BeNCShopAnnotation.h"
#define ANNOTATION_VIEW_WIDTH 57
#define ANNOTATION_VIEW_HEIGTH 64
@implementation BeNCAnnotationView

@synthesize numberlb,numberImageView,backgroudImage;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.backgroudImage = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"images.jpg"]];
        BeNCShopAnnotation *shopannotation = (BeNCShopAnnotation *)annotation;
        self.backgroudImage.imageURL =[NSURL URLWithString:shopannotation.shop.shop_icon_link];
        [self.backgroudImage setFrame:CGRectMake(7, 7, 40, 40)];
        [self addSubview:self.backgroudImage];
        
        self.numberImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"numberView.png"]];
        self.numberImageView.frame = CGRectMake(40, 40, 20, 20);
        
        self.numberlb = [[UILabel alloc]initWithFrame:numberImageView.frame];
        
        self.numberlb.textColor = [UIColor whiteColor];
        self.numberlb.backgroundColor = [UIColor clearColor];
        self.numberlb.textAlignment = UITextAlignmentCenter;
        self.numberlb.font = [UIFont systemFontOfSize:10];
        self.numberlb.text = @"1";
        
        UIImage *img = [UIImage imageNamed:@"MapFrame.png"];
        self.image = img;
        [self addSubview:self.numberImageView];
        [self addSubview:self.numberlb];
        [self setFrame:CGRectMake(0, 0, ANNOTATION_VIEW_WIDTH  , ANNOTATION_VIEW_HEIGTH)];
        [self setCenterOffset:CGPointMake(self.frame.origin.x, self.frame.origin.y-25)];
                       // Initialization code
    }
    return self;

}

@end
