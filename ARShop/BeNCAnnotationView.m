//
//  BeNCAnnotationView.m
//  ARShop
//
//  Created by Applehouse on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCAnnotationView.h"

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
        self.backgroudImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"images.jpg"]];
        [self.backgroudImage setFrame:CGRectMake(5, 5, 40, 40)];
        [self addSubview:self.backgroudImage];
        
        self.numberImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"numberView.png"]];
        self.numberImageView.frame = CGRectMake(40, 40, 20, 20);
        
        self.numberlb = [[UILabel alloc]initWithFrame:numberImageView.frame];
        
        self.numberlb.textColor = [UIColor whiteColor];
        self.numberlb.backgroundColor = [UIColor clearColor];
        self.numberlb.textAlignment = UITextAlignmentCenter;
        self.numberlb.font = [UIFont systemFontOfSize:10];
        self.numberlb.text = @"1";
        [self addSubview:self.numberImageView];
        [self addSubview:self.numberlb];
        [self setFrame:CGRectMake(0, 0, 55, 60)];
        [self setCenterOffset:CGPointMake(self.frame.origin.x, self.frame.origin.y-25)];
                       // Initialization code
    }
    return self;

}

@end
