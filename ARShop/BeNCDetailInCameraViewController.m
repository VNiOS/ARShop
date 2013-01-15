//
//  BeNCDetailInCameraViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCDetailInCameraViewController.h"
#import "BeNCShopEntity.h"
#import "BeNCArrow.h"
#import "BeNCDetailShopInCamera.h"
#import "BeNCArrow.h"
#import <QuartzCore/QuartzCore.h>
#define widthFrame 30
#define heightFrame 45


@interface BeNCDetailInCameraViewController ()

@end

@implementation BeNCDetailInCameraViewController
@synthesize shop,delegate,index;

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {

        [self setContentForView:shopEntity];
    }
    return self;
}


- (void)setContentForView:(BeNCShopEntity *)shopEntity
{
    detailShop = [[BeNCDetailShopInCamera alloc]initWithShop:shopEntity];
    detailShop.delegate = self;
    CGRect frame = detailShop.frame;
    frame.size.height = 70;
    self.view.frame = frame;    
    CGRect frame1 = detailShop.frame;
    frame1.origin.x = 0;
    frame1.origin.y = 30;
    detailShop.frame = frame1;
    [self.view addSubview:detailShop];
    
    arrowImage = [[BeNCArrow alloc]initWithShop:shopEntity];
    arrowImage.frame = CGRectMake(frame.size.width/2 - 15, 0 , 20, 30);
    [self.view addSubview:arrowImage];
    [self.view setBackgroundColor:[UIColor clearColor]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)setIndexForView:(int )aIndex
{
    index = aIndex;
}
- (void)didTouchesToView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeclectView:)]) {
        NSLog(@"test delegate co den k");
        [self.delegate didSeclectView:self.index];
    }
}
- (void)dealloc
{
    [timer release];
    [super dealloc];
}

@end
