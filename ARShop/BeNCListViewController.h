//
//  BeNCListViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BeNCListViewController : UIViewController


-(void)didUpdateLocation:(NSNotification *)notifi;
-(void)didUpdateHeading:(NSNotification *)notifi;
@end
