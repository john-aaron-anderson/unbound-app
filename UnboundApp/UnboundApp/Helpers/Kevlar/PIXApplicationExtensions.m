//
// Created by Ryan Harter on 10/25/17.
// Copyright (c) 2017 Pixite Apps LLC. All rights reserved.
//

#import "PIXApplicationExtensions.h"


@implementation NSApplication (Dummy)

- (BOOL)isActivated {
#ifdef TRIAL
	return TRIAL;
#else
	return YES;
#endif
}

@end

