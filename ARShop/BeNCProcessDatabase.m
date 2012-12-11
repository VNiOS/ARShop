//
//  BeNCProcessDatabase.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCProcessDatabase.h"

@implementation BeNCProcessDatabase

static BeNCProcessDatabase *shareDatabase = nil;

+(BeNCProcessDatabase*)sharedMySingleton
{
	@synchronized([BeNCProcessDatabase class])
	{
		if (!shareDatabase)
			[[self alloc] init];
        
		return shareDatabase;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([BeNCProcessDatabase class])
	{
		NSAssert(shareDatabase == nil, @"Attempted to allocate a second instance of a singleton.");
		shareDatabase = [super alloc];
		return shareDatabase;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
    
	return self;
}

-(void)sayHello {
	NSLog(@"Hello World!");
}


@end
