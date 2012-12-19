//
//  BeNCShopGroupView.m
//  ARShop
//
//  Created by Applehouse on 12/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCShopGroupView.h"

@implementation BeNCShopGroupView
@synthesize button=_button,annotation;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
        [self addSubview:_button];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
