//
//  BeNCMenuViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCMenuViewController.h"
#import "BeNCProcessDatabase.h"
#define kSelectedTab	@"SelectedTAB"

@interface BeNCMenuViewController ()

@end

@implementation BeNCMenuViewController
@synthesize tabViewControllers,tabBarHolder,delegate,initTab,tabItemsArray;



- (id)initWithTabViewControllers:(NSMutableArray *)tbControllers tabItems:(NSMutableArray *)tbItems initialTab:(int)iTab {
	if ((self = [super init])) {
		self.view.frame = [UIScreen mainScreen].bounds;
		initTab = iTab;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		if ([defaults integerForKey:kSelectedTab]) {
			initTab = [defaults integerForKey:kSelectedTab];
		}
		NSLog(@"%d", initTab);
		tabViewControllers = [[NSMutableArray alloc] initWithCapacity:[tbControllers count]];
		tabViewControllers = tbControllers;
		
		tabItemsArray = [[NSMutableArray alloc] initWithCapacity:[tbItems count]];
		tabItemsArray = tbItems;
	}
    return self;
}

- (void)viewDidLoad
{
   [[BeNCProcessDatabase sharedMyDatabase] getDatebase ];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDatabase:) name:@"GetDatabase" object:nil];
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)getDatabase:(NSNotification *)notification
{
     NSArray *arrayShop = (NSArray *)[notification object];
    NSLog(@"number shop = %i",[arrayShop count]);
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


-(void)initialTab:(int)tabIndex {
	[self activateController:tabIndex];
	[self activateTabItem:tabIndex];
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//Create a view holder to store the tabbar items
	tabBarHolder = [[UIView alloc] initWithFrame:CGRectMake(150, 271, 480, 49)];
	tabBarHolder.backgroundColor = [UIColor clearColor];
	//add it as a subview
	[self.view addSubview:tabBarHolder];
	//loop thru all the view controllers and add their views to self
	for (int i = [tabViewControllers count]-1; i >= 0; i--) {
		[self.view addSubview:[[tabViewControllers objectAtIndex:i] view]];
	}
	
	//loop thru all the tabbar items and add them to the tabBarHolder
	
	for (int i = [tabItemsArray count]-1; i >= 0; i--) {
		[[tabItemsArray objectAtIndex:i] setDelegate:self];
		[self.tabBarHolder addSubview:[tabItemsArray objectAtIndex:i]];
		//initTab is the index of the tabbar and viewcontroller that you decide to start the app with
		if (i == initTab) {
			[[tabItemsArray objectAtIndex:i] toggleOn:YES];
		}
	}
	[self.view bringSubviewToFront:tabBarHolder];
	//show/hide tabbars and controllers with a particular index
	[self initialTab:initTab];
}
//loop thru all tab bar items and set their toogle State to YES/NO
-(void)activateTabItem:(int)index {
	for (int i = [tabItemsArray count]; i < [tabItemsArray count]; i++) {
		if (i == index) {
			[[tabItemsArray objectAtIndex:i] toggleOn:YES];
		} else {
			[[tabItemsArray objectAtIndex:i] toggleOn:NO];
		}
	}
}
//loop thru all UIViewControllers items and set their toogle State to YES/NO
-(void)activateController:(int)index {
	for (int i = 0; i < [tabViewControllers count]; i++) {
		if (i == index) {
			[[tabViewControllers objectAtIndex:i] view].hidden = NO;
		} else {
			[[tabViewControllers objectAtIndex:i] view].hidden = YES;
		}
	}
}
//protocol used to communicate between the buttons and the tabbar
#pragma mark -
#pragma mark GTabTabItemDelegate action
- (void)selectedItem:(BeNCTabbarItem *)button {
	int indexC = 0;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger tabIndex;
	for (BeNCTabbarItem *tb in tabItemsArray) {		
		if (tb == button) {
			[tb toggleOn:YES];
			[self activateController:indexC];
			tabIndex = indexC;
			[defaults setInteger:tabIndex forKey:kSelectedTab];
		} else {
			[tb toggleOn:NO];
		}
		indexC++;
	}	 
}

- (void)dealloc
{
    [tabBarHolder release];
	[tabViewControllers release];
	[tabItemsArray release];
    [super dealloc];
}


@end
