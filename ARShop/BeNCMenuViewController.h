//
//  BeNCMenuViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeNCTabbarItem.h"

@protocol BeNCMenuViewControllerDelegate
- (void)addController:(id)controller;
@end

@interface BeNCMenuViewController : UIViewController<BeNCTabbarItemDelegate>
{
    UIView *tabBarHolder;
	NSMutableArray *tabViewControllers;
	NSMutableArray *tabItemsArray;
	int initTab; 
    int selectedTab;
}

@property int initTab;
@property (nonatomic, retain) UIView *tabBarHolder;
@property (nonatomic, assign) id <BeNCMenuViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *tabViewControllers;
@property (nonatomic, retain) NSMutableArray *tabItemsArray;
@property (nonatomic) int selectedTab;
//actions
- (id)initWithTabViewControllers:(NSMutableArray *)tbControllers tabItems:(NSMutableArray *)tbItems initialTab:(int)iTab;
-(void)initialTab:(int)tabIndex;
-(void)activateController:(int)index;
-(void)activateTabItem:(int)index;
@end
